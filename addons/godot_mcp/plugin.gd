@tool
extends EditorPlugin

const MCPServer = preload("res://addons/godot_mcp/mcp_server.gd")
const MCPLocalization = preload("res://addons/godot_mcp/i18n/localization.gd")

var mcp_server: MCPServer
var dock: Control
var _i18n: MCPLocalization

# Plugin settings
var settings := {
	"port": 3000,
	"host": "127.0.0.1",
	"auto_start": true,
	"debug_mode": true,
	"disabled_tools": [],
	"language": "",  # Empty means auto-detect
	"collapsed_categories": []  # Categories that are collapsed
}

const SETTINGS_PATH = "user://godot_mcp_settings.json"

# UI references
var _tab_container: TabContainer
var _status_label: Label
var _status_indicator: ColorRect
var _port_spin: SpinBox
var _endpoint_label: Label
var _conn_label: Label
var _tool_list_container: VBoxContainer
var _tool_count_label: Label
var _category_containers: Dictionary = {}
var _tool_checkboxes: Dictionary = {}
var _language_option: OptionButton

# CLI config UI references
var _cli_scope_option: OptionButton
var _claude_cli_edit: TextEdit
var _codex_cli_edit: TextEdit
var _gemini_cli_edit: TextEdit
var _current_cli_scope: String = "user"


# Localization helper
func _tr(key: String) -> String:
	if _i18n:
		return _i18n.get_text(key)
	return key


func _enter_tree() -> void:
	_load_settings()

	# Initialize localization
	_i18n = MCPLocalization.get_instance()
	if not settings.language.is_empty():
		_i18n.set_language(settings.language)

	mcp_server = MCPServer.new()
	mcp_server.name = "MCPServer"
	add_child(mcp_server)

	mcp_server.initialize(settings.port, settings.host, settings.debug_mode)
	mcp_server.set_disabled_tools(settings.disabled_tools)

	_create_dock()

	if settings.auto_start:
		mcp_server.start()
		_update_status_ui()

	mcp_server.server_started.connect(_on_server_started)
	mcp_server.server_stopped.connect(_on_server_stopped)
	mcp_server.client_connected.connect(_update_connection_count)
	mcp_server.client_disconnected.connect(_update_connection_count)

	print("[Godot MCP] Plugin loaded")


func _exit_tree() -> void:
	if mcp_server:
		mcp_server.stop()
		mcp_server.queue_free()

	if dock:
		remove_control_from_docks(dock)
		dock.queue_free()

	print("[Godot MCP] Plugin unloaded")


# Get editor scale factor for DPI-aware sizing
func _get_editor_scale() -> float:
	var editor = get_editor_interface()
	if editor:
		return editor.get_editor_scale()
	return 1.0


# Scale a value by editor scale
func _scaled(value: float) -> float:
	return value * _get_editor_scale()


# Scale a Vector2 by editor scale
func _scaled_vec(vec: Vector2) -> Vector2:
	return vec * _get_editor_scale()


func _create_dock() -> void:
	dock = _create_dock_ui()
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)


func _create_dock_ui() -> Control:
	var main_panel = VBoxContainer.new()
	main_panel.name = "GodotMCP"
	main_panel.custom_minimum_size = _scaled_vec(Vector2(280, 400))

	# Header
	var header = _create_header()
	main_panel.add_child(header)

	# Tab Container
	_tab_container = TabContainer.new()
	_tab_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_tab_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_panel.add_child(_tab_container)

	# Create tabs
	var server_tab = _create_server_tab()
	server_tab.name = _tr("tab_server")
	_tab_container.add_child(server_tab)

	var tools_tab = _create_tools_tab()
	tools_tab.name = _tr("tab_tools")
	_tab_container.add_child(tools_tab)

	var config_tab = _create_config_tab()
	config_tab.name = _tr("tab_config")
	_tab_container.add_child(config_tab)

	return main_panel


func _create_header() -> Control:
	var header = HBoxContainer.new()
	header.custom_minimum_size.y = _scaled(40)

	var margin = MarginContainer.new()
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_theme_constant_override("margin_left", int(_scaled(12)))
	margin.add_theme_constant_override("margin_right", int(_scaled(12)))
	margin.add_theme_constant_override("margin_top", int(_scaled(8)))
	margin.add_theme_constant_override("margin_bottom", int(_scaled(8)))
	header.add_child(margin)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", int(_scaled(10)))
	margin.add_child(hbox)

	# Status indicator
	_status_indicator = ColorRect.new()
	_status_indicator.custom_minimum_size = _scaled_vec(Vector2(12, 12))
	_status_indicator.color = Color(0.9, 0.3, 0.3)
	var indicator_container = CenterContainer.new()
	indicator_container.add_child(_status_indicator)
	hbox.add_child(indicator_container)

	# Title
	var title = Label.new()
	title.text = "Godot MCP Server"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(title)

	# Status label
	_status_label = Label.new()
	_status_label.text = _tr("status_stopped")
	_status_label.add_theme_color_override("font_color", Color(0.9, 0.3, 0.3))
	hbox.add_child(_status_label)

	return header


func _create_server_tab() -> Control:
	var scroll = ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var margin = MarginContainer.new()
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_theme_constant_override("margin_left", int(_scaled(12)))
	margin.add_theme_constant_override("margin_right", int(_scaled(12)))
	margin.add_theme_constant_override("margin_top", int(_scaled(12)))
	margin.add_theme_constant_override("margin_bottom", int(_scaled(12)))
	scroll.add_child(margin)

	var content = VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", int(_scaled(16)))
	margin.add_child(content)

	# Server Status Section
	var status_section = _create_section(_tr("server_status"))
	content.add_child(status_section)

	var status_grid = GridContainer.new()
	status_grid.columns = 2
	status_grid.add_theme_constant_override("h_separation", int(_scaled(12)))
	status_grid.add_theme_constant_override("v_separation", int(_scaled(8)))
	status_section.add_child(status_grid)

	var endpoint_title = Label.new()
	endpoint_title.text = _tr("endpoint")
	status_grid.add_child(endpoint_title)

	_endpoint_label = Label.new()
	_endpoint_label.text = "http://%s:%d/mcp" % [settings.host, settings.port]
	_endpoint_label.add_theme_color_override("font_color", Color(0.4, 0.7, 1.0))
	_endpoint_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	status_grid.add_child(_endpoint_label)

	var conn_title = Label.new()
	conn_title.text = _tr("connections")
	status_grid.add_child(conn_title)

	_conn_label = Label.new()
	_conn_label.text = "0"
	status_grid.add_child(_conn_label)

	# Settings Section
	var settings_section = _create_section(_tr("settings"))
	content.add_child(settings_section)

	var settings_grid = GridContainer.new()
	settings_grid.columns = 2
	settings_grid.add_theme_constant_override("h_separation", int(_scaled(12)))
	settings_grid.add_theme_constant_override("v_separation", int(_scaled(8)))
	settings_section.add_child(settings_grid)

	var port_label = Label.new()
	port_label.text = _tr("port")
	settings_grid.add_child(port_label)

	_port_spin = SpinBox.new()
	_port_spin.min_value = 1024
	_port_spin.max_value = 65535
	_port_spin.value = settings.port
	_port_spin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_port_spin.value_changed.connect(_on_port_changed)
	settings_grid.add_child(_port_spin)

	var auto_start_check = CheckBox.new()
	auto_start_check.text = _tr("auto_start")
	auto_start_check.button_pressed = settings.auto_start
	auto_start_check.toggled.connect(_on_auto_start_toggled)
	settings_section.add_child(auto_start_check)

	var debug_check = CheckBox.new()
	debug_check.text = _tr("debug_log")
	debug_check.button_pressed = settings.debug_mode
	debug_check.toggled.connect(_on_debug_toggled)
	settings_section.add_child(debug_check)

	# Language selector
	var lang_container = HBoxContainer.new()
	lang_container.add_theme_constant_override("separation", int(_scaled(8)))
	settings_section.add_child(lang_container)

	var lang_label = Label.new()
	lang_label.text = _tr("language")
	lang_container.add_child(lang_label)

	_language_option = OptionButton.new()
	_language_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var languages = _i18n.get_available_languages()
	var current_lang = _i18n.get_language()
	var idx = 0
	for lang_code in languages:
		_language_option.add_item(languages[lang_code], idx)
		_language_option.set_item_metadata(idx, lang_code)
		if lang_code == current_lang:
			_language_option.select(idx)
		idx += 1
	_language_option.item_selected.connect(_on_language_changed)
	lang_container.add_child(_language_option)

	# Control Buttons
	var btn_container = HBoxContainer.new()
	btn_container.add_theme_constant_override("separation", int(_scaled(8)))
	content.add_child(btn_container)

	var start_btn = Button.new()
	start_btn.text = _tr("btn_start")
	start_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	start_btn.custom_minimum_size.y = _scaled(32)
	start_btn.pressed.connect(_on_start_pressed)
	btn_container.add_child(start_btn)

	var stop_btn = Button.new()
	stop_btn.text = _tr("btn_stop")
	stop_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stop_btn.custom_minimum_size.y = _scaled(32)
	stop_btn.pressed.connect(_on_stop_pressed)
	btn_container.add_child(stop_btn)

	# Spacer to push author info to bottom
	var spacer = Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(spacer)

	# Author Info Section
	var author_separator = HSeparator.new()
	content.add_child(author_separator)

	var author_section = VBoxContainer.new()
	author_section.add_theme_constant_override("separation", int(_scaled(4)))
	content.add_child(author_section)

	var author_title = Label.new()
	author_title.text = _tr("about")
	author_title.add_theme_color_override("font_color", Color(0.4, 0.7, 1.0))
	author_section.add_child(author_title)

	var author_info = VBoxContainer.new()
	author_info.add_theme_constant_override("separation", int(_scaled(2)))
	author_section.add_child(author_info)

	var author_label = Label.new()
	author_label.text = _tr("author") + " LIDAXIAN"
	author_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	author_info.add_child(author_label)

	var github_container = HBoxContainer.new()
	github_container.add_theme_constant_override("separation", int(_scaled(4)))
	author_info.add_child(github_container)

	var github_label = Label.new()
	github_label.text = "GitHub:"
	github_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	github_container.add_child(github_label)

	var github_btn = LinkButton.new()
	github_btn.text = "https://github.com/DaxianLee/godot-mcp"
	github_btn.uri = "https://github.com/DaxianLee/godot-mcp"
	github_btn.underline = LinkButton.UNDERLINE_MODE_ON_HOVER
	github_container.add_child(github_btn)

	var wechat_label = Label.new()
	wechat_label.text = _tr("wechat") + " lidaxian-AI"
	wechat_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	author_info.add_child(wechat_label)

	return scroll


func _create_tools_tab() -> Control:
	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Header
	var header_margin = MarginContainer.new()
	header_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_margin.add_theme_constant_override("margin_left", int(_scaled(12)))
	header_margin.add_theme_constant_override("margin_right", int(_scaled(12)))
	header_margin.add_theme_constant_override("margin_top", int(_scaled(12)))
	header_margin.add_theme_constant_override("margin_bottom", int(_scaled(8)))
	vbox.add_child(header_margin)

	var header_vbox = VBoxContainer.new()
	header_vbox.add_theme_constant_override("separation", int(_scaled(8)))
	header_margin.add_child(header_vbox)

	_tool_count_label = Label.new()
	_tool_count_label.text = _tr("tools_enabled") % [0, 0]
	header_vbox.add_child(_tool_count_label)

	# Collapse/Expand all buttons
	var collapse_btn_container = HBoxContainer.new()
	collapse_btn_container.add_theme_constant_override("separation", int(_scaled(8)))
	header_vbox.add_child(collapse_btn_container)

	var expand_all_btn = Button.new()
	expand_all_btn.text = _tr("btn_expand_all")
	expand_all_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	expand_all_btn.pressed.connect(_on_expand_all_categories)
	collapse_btn_container.add_child(expand_all_btn)

	var collapse_all_btn = Button.new()
	collapse_all_btn.text = _tr("btn_collapse_all")
	collapse_all_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	collapse_all_btn.pressed.connect(_on_collapse_all_categories)
	collapse_btn_container.add_child(collapse_all_btn)

	# Select/Deselect all buttons
	var bulk_btn_container = HBoxContainer.new()
	bulk_btn_container.add_theme_constant_override("separation", int(_scaled(8)))
	header_vbox.add_child(bulk_btn_container)

	var select_all_btn = Button.new()
	select_all_btn.text = _tr("btn_select_all")
	select_all_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	select_all_btn.pressed.connect(_on_select_all_tools)
	bulk_btn_container.add_child(select_all_btn)

	var deselect_all_btn = Button.new()
	deselect_all_btn.text = _tr("btn_deselect_all")
	deselect_all_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	deselect_all_btn.pressed.connect(_on_deselect_all_tools)
	bulk_btn_container.add_child(deselect_all_btn)

	vbox.add_child(HSeparator.new())

	# Scrollable tool list
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll)

	var tool_margin = MarginContainer.new()
	tool_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tool_margin.add_theme_constant_override("margin_left", int(_scaled(12)))
	tool_margin.add_theme_constant_override("margin_right", int(_scaled(12)))
	tool_margin.add_theme_constant_override("margin_top", int(_scaled(8)))
	tool_margin.add_theme_constant_override("margin_bottom", int(_scaled(12)))
	scroll.add_child(tool_margin)

	_tool_list_container = VBoxContainer.new()
	_tool_list_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_tool_list_container.add_theme_constant_override("separation", int(_scaled(8)))
	tool_margin.add_child(_tool_list_container)

	call_deferred("_populate_tools_list")

	return vbox


func _create_config_tab() -> Control:
	var scroll = ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var margin = MarginContainer.new()
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_theme_constant_override("margin_left", int(_scaled(12)))
	margin.add_theme_constant_override("margin_right", int(_scaled(12)))
	margin.add_theme_constant_override("margin_top", int(_scaled(12)))
	margin.add_theme_constant_override("margin_bottom", int(_scaled(12)))
	scroll.add_child(margin)

	var content = VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", int(_scaled(16)))
	margin.add_child(content)

	# Info - IDE 一键配置
	var ide_header = Label.new()
	ide_header.text = _tr("ide_config")
	ide_header.add_theme_color_override("font_color", Color(0.4, 0.7, 1.0))
	content.add_child(ide_header)

	var info_label = Label.new()
	info_label.text = _tr("ide_config_desc")
	info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	content.add_child(info_label)

	# Trae
	content.add_child(_create_config_section(
		"Trae",
		_get_trae_config_path(),
		_get_mcp_config(),
		"trae"
	))

	# Cursor
	content.add_child(_create_config_section(
		"Cursor",
		_get_cursor_config_path(),
		_get_mcp_config(),
		"cursor"
	))

	# Windsurf
	content.add_child(_create_config_section(
		"Windsurf",
		_get_windsurf_config_path(),
		_get_windsurf_config(),
		"windsurf"
	))

	# 分隔线
	var separator = HSeparator.new()
	separator.add_theme_constant_override("separation", int(_scaled(16)))
	content.add_child(separator)

	# CLI 命令行配置说明
	var cli_header = Label.new()
	cli_header.text = _tr("cli_config")
	cli_header.add_theme_color_override("font_color", Color(0.4, 0.7, 1.0))
	content.add_child(cli_header)

	var cli_desc = Label.new()
	cli_desc.text = _tr("cli_config_desc")
	cli_desc.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	content.add_child(cli_desc)

	# Scope 选择器
	var scope_section = HBoxContainer.new()
	scope_section.add_theme_constant_override("separation", int(_scaled(8)))
	content.add_child(scope_section)

	var scope_label = Label.new()
	scope_label.text = _tr("config_scope")
	scope_section.add_child(scope_label)

	_cli_scope_option = OptionButton.new()
	_cli_scope_option.add_item(_tr("scope_user"), 0)
	_cli_scope_option.add_item(_tr("scope_project"), 1)
	_cli_scope_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_cli_scope_option.item_selected.connect(_on_cli_scope_changed)
	scope_section.add_child(_cli_scope_option)

	# Claude CLI
	content.add_child(_create_dynamic_cli_section("Claude Code", "claude"))

	# Codex CLI
	content.add_child(_create_dynamic_cli_section("Codex", "codex"))

	# Gemini CLI
	content.add_child(_create_dynamic_cli_section("Gemini", "gemini"))

	return scroll


func _create_section(title: String) -> VBoxContainer:
	var section = VBoxContainer.new()
	section.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	section.add_theme_constant_override("separation", int(_scaled(8)))

	var title_label = Label.new()
	title_label.text = title
	title_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	section.add_child(title_label)

	return section


func _create_config_section(title: String, filepath: String, config: String, config_type: String) -> VBoxContainer:
	var section = _create_section(title)

	var file_label = Label.new()
	file_label.text = filepath
	file_label.add_theme_color_override("font_color", Color(0.5, 0.6, 0.7))
	file_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	section.add_child(file_label)

	# Config display
	var code_edit = TextEdit.new()
	code_edit.text = config
	code_edit.editable = false
	code_edit.custom_minimum_size.y = _scaled(80)
	code_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	code_edit.scroll_fit_content_height = true
	section.add_child(code_edit)

	# Buttons
	var btn_container = HBoxContainer.new()
	btn_container.add_theme_constant_override("separation", int(_scaled(8)))
	section.add_child(btn_container)

	var config_btn = Button.new()
	config_btn.text = _tr("btn_one_click")
	config_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	config_btn.pressed.connect(func(): _write_config_file(config_type, filepath, config, title))
	btn_container.add_child(config_btn)

	var copy_btn = Button.new()
	copy_btn.text = _tr("btn_copy")
	copy_btn.pressed.connect(func(): _copy_to_clipboard(config, title))
	btn_container.add_child(copy_btn)

	return section


func _create_category_section(category: String, tools: Array) -> VBoxContainer:
	var section = VBoxContainer.new()
	section.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	section.add_theme_constant_override("separation", int(_scaled(4)))

	# Category header (clickable to collapse/expand)
	var header = HBoxContainer.new()
	header.add_theme_constant_override("separation", int(_scaled(4)))
	section.add_child(header)

	# Collapse/expand toggle button
	var is_collapsed = category in settings.collapsed_categories
	var toggle_btn = Button.new()
	toggle_btn.text = "▶" if is_collapsed else "▼"
	toggle_btn.flat = true
	toggle_btn.custom_minimum_size = _scaled_vec(Vector2(20, 20))
	toggle_btn.pressed.connect(func(): _on_category_collapse_toggled(category))
	header.add_child(toggle_btn)

	var category_check = CheckBox.new()
	category_check.button_pressed = true
	category_check.toggled.connect(func(pressed): _on_category_toggled(category, pressed))
	header.add_child(category_check)

	var category_keys = {
		"scene": "cat_scene", "node": "cat_node", "script": "cat_script",
		"resource": "cat_resource", "filesystem": "cat_filesystem", "project": "cat_project",
		"editor": "cat_editor", "debug": "cat_debug", "animation": "cat_animation",
		"material": "cat_material", "shader": "cat_shader", "lighting": "cat_lighting",
		"particle": "cat_particle", "tilemap": "cat_tilemap", "geometry": "cat_geometry",
		"physics": "cat_physics", "navigation": "cat_navigation", "audio": "cat_audio",
		"ui": "cat_ui", "signal": "cat_signal", "group": "cat_group"
	}
	var display_category = _tr(category_keys.get(category, category)) if category in category_keys else category.capitalize()

	var category_label = Label.new()
	category_label.text = display_category
	category_label.add_theme_color_override("font_color", Color(0.4, 0.7, 1.0))
	category_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	category_label.mouse_filter = Control.MOUSE_FILTER_STOP
	# Make label clickable to toggle collapse
	category_label.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_on_category_collapse_toggled(category)
	)
	header.add_child(category_label)

	var count_label = Label.new()
	count_label.name = "CountLabel"
	count_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	header.add_child(count_label)

	# Tools list (indented)
	var tools_margin = MarginContainer.new()
	tools_margin.name = "ToolsMargin"
	tools_margin.add_theme_constant_override("margin_left", int(_scaled(24)))
	tools_margin.visible = not is_collapsed
	section.add_child(tools_margin)

	var tools_vbox = VBoxContainer.new()
	tools_vbox.name = "ToolsList"
	tools_vbox.add_theme_constant_override("separation", int(_scaled(2)))
	tools_margin.add_child(tools_vbox)

	for tool_def in tools:
		var tool_name = tool_def.get("name", "")
		# Always add category prefix to match _tool_definitions naming
		var full_name = "%s_%s" % [category, tool_name]
		var display_name = tool_name.replace("_", " ").capitalize()

		# Create a container for tool checkbox and description
		var tool_container = VBoxContainer.new()
		tool_container.add_theme_constant_override("separation", int(_scaled(2)))
		tools_vbox.add_child(tool_container)

		var tool_check = CheckBox.new()
		tool_check.text = display_name
		tool_check.button_pressed = not (full_name in settings.disabled_tools)
		tool_check.toggled.connect(func(pressed): _on_tool_toggled(full_name, pressed))
		tool_container.add_child(tool_check)

		# Add description label with i18n support
		var desc_key = "tool_%s_desc" % full_name
		var desc_text = _tr(desc_key)
		# If no translation found (returns the key), don't show description
		if desc_text != desc_key:
			var desc_label = Label.new()
			desc_label.text = desc_text
			desc_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
			desc_label.add_theme_font_size_override("font_size", int(_scaled(11)))
			desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			var desc_margin = MarginContainer.new()
			desc_margin.add_theme_constant_override("margin_left", int(_scaled(24)))
			desc_margin.add_child(desc_label)
			tool_container.add_child(desc_margin)

		_tool_checkboxes[full_name] = tool_check

	_category_containers[category] = {
		"section": section,
		"checkbox": category_check,
		"count_label": count_label,
		"tools_list": tools_vbox,
		"tools_margin": tools_margin,
		"toggle_btn": toggle_btn
	}

	_update_category_count(category)

	return section


func _populate_tools_list() -> void:
	if not mcp_server or not _tool_list_container:
		return

	for child in _tool_list_container.get_children():
		child.queue_free()
	_category_containers.clear()
	_tool_checkboxes.clear()

	var tools_by_category = mcp_server.get_tools_by_category()

	for category in tools_by_category:
		var tools = tools_by_category[category]
		var section = _create_category_section(category, tools)
		_tool_list_container.add_child(section)

	_update_tool_count()


func _update_category_count(category: String) -> void:
	if not _category_containers.has(category):
		return

	var container = _category_containers[category]
	var count_label = container["count_label"] as Label
	var category_check = container["checkbox"] as CheckBox

	# Count tools in this category using _tool_checkboxes
	var total = 0
	var enabled = 0

	for tool_name in _tool_checkboxes:
		if tool_name.begins_with(category + "_"):
			total += 1
			if _tool_checkboxes[tool_name].button_pressed:
				enabled += 1

	count_label.text = "%d/%d" % [enabled, total]
	category_check.set_pressed_no_signal(enabled == total)


func _update_tool_count() -> void:
	if not _tool_count_label:
		return

	var total = _tool_checkboxes.size()
	var enabled = 0

	for tool_name in _tool_checkboxes:
		if _tool_checkboxes[tool_name].button_pressed:
			enabled += 1

	_tool_count_label.text = _tr("tools_enabled") % [enabled, total]


func _update_status_ui() -> void:
	if not dock:
		return

	var is_running = mcp_server and mcp_server.is_running()
	var color = Color(0.2, 0.8, 0.2) if is_running else Color(0.9, 0.3, 0.3)

	if _status_indicator:
		_status_indicator.color = color

	if _status_label:
		_status_label.text = _tr("status_running") if is_running else _tr("status_stopped")
		_status_label.add_theme_color_override("font_color", color)

	if _endpoint_label:
		_endpoint_label.text = "http://%s:%d/mcp" % [settings.host, settings.port]


func _update_connection_count() -> void:
	if _conn_label and mcp_server:
		_conn_label.text = "%d" % mcp_server.get_connection_count()


# Configuration helpers
func _get_home_dir() -> String:
	var home = OS.get_environment("HOME")
	if home.is_empty():
		home = OS.get_environment("USERPROFILE")
	return home


func _get_claude_config_path() -> String:
	var home = _get_home_dir()
	match OS.get_name():
		"macOS":
			return home + "/Library/Application Support/Claude/claude_desktop_config.json"
		"Windows":
			return OS.get_environment("APPDATA") + "/Claude/claude_desktop_config.json"
		_:
			return home + "/.config/Claude/claude_desktop_config.json"


func _get_cursor_config_path() -> String:
	return _get_home_dir() + "/.cursor/mcp.json"


func _get_windsurf_config_path() -> String:
	return _get_home_dir() + "/.codeium/windsurf/mcp_config.json"


func _get_mcp_config() -> String:
	return JSON.stringify({
		"mcpServers": {
			"godot-mcp": {
				"url": "http://%s:%d/mcp" % [settings.host, settings.port]
			}
		}
	}, "  ")


func _get_windsurf_config() -> String:
	return JSON.stringify({
		"mcpServers": {
			"godot-mcp": {
				"serverUrl": "http://%s:%d/mcp" % [settings.host, settings.port]
			}
		}
	}, "  ")


func _get_trae_config_path() -> String:
	var home = _get_home_dir()
	match OS.get_name():
		"macOS":
			return home + "/Library/Application Support/Trae CN/User/mcp.json"
		"Windows":
			return OS.get_environment("APPDATA") + "/Trae CN/User/mcp.json"
		_:
			return home + "/.config/Trae CN/User/mcp.json"


func _get_claude_cli_command_local() -> String:
	return "claude mcp add --scope project --transport http godot-mcp http://%s:%d/mcp" % [settings.host, settings.port]


func _get_claude_cli_command_user() -> String:
	return "claude mcp add --scope user --transport http godot-mcp http://%s:%d/mcp" % [settings.host, settings.port]


func _get_codex_command() -> String:
	return "codex mcp add --transport http godot-mcp http://%s:%d/mcp" % [settings.host, settings.port]


func _create_cli_section(title: String, command: String, description: String) -> VBoxContainer:
	var section = _create_section(title)

	var desc_label = Label.new()
	desc_label.text = description
	desc_label.add_theme_color_override("font_color", Color(0.5, 0.6, 0.7))
	section.add_child(desc_label)

	# Command display
	var code_edit = TextEdit.new()
	code_edit.text = command
	code_edit.editable = false
	code_edit.custom_minimum_size.y = _scaled(40)
	code_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	code_edit.scroll_fit_content_height = true
	section.add_child(code_edit)

	# Copy button
	var copy_btn = Button.new()
	copy_btn.text = _tr("btn_copy_cmd")
	copy_btn.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	copy_btn.pressed.connect(func(): _copy_to_clipboard(command, title))
	section.add_child(copy_btn)

	return section


func _create_dynamic_cli_section(title: String, cli_type: String) -> VBoxContainer:
	var section = _create_section(title)

	# Command display
	var code_edit = TextEdit.new()
	code_edit.editable = false
	code_edit.custom_minimum_size.y = _scaled(40)
	code_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	code_edit.scroll_fit_content_height = true
	section.add_child(code_edit)

	# Store reference for dynamic updates
	if cli_type == "claude":
		_claude_cli_edit = code_edit
		code_edit.text = _get_claude_cli_command(_current_cli_scope)
	elif cli_type == "codex":
		_codex_cli_edit = code_edit
		code_edit.text = _get_codex_cli_command(_current_cli_scope)
	elif cli_type == "gemini":
		_gemini_cli_edit = code_edit
		code_edit.text = _get_gemini_cli_command(_current_cli_scope)

	# Copy button
	var copy_btn = Button.new()
	copy_btn.text = _tr("btn_copy_cmd")
	copy_btn.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	copy_btn.pressed.connect(func(): _copy_to_clipboard(code_edit.text, title))
	section.add_child(copy_btn)

	return section


func _on_cli_scope_changed(index: int) -> void:
	if index == 0:
		_current_cli_scope = "user"
	else:
		_current_cli_scope = "project"

	# Update CLI commands
	_update_cli_commands()


func _update_cli_commands() -> void:
	if _claude_cli_edit:
		_claude_cli_edit.text = _get_claude_cli_command(_current_cli_scope)
	if _codex_cli_edit:
		_codex_cli_edit.text = _get_codex_cli_command(_current_cli_scope)
	if _gemini_cli_edit:
		_gemini_cli_edit.text = _get_gemini_cli_command(_current_cli_scope)


func _get_claude_cli_command(scope: String) -> String:
	return "claude mcp add --scope %s --transport http godot-mcp http://%s:%d/mcp" % [scope, settings.host, settings.port]


func _get_codex_cli_command(scope: String) -> String:
	return "codex mcp add --scope %s --transport http godot-mcp http://%s:%d/mcp" % [scope, settings.host, settings.port]


func _get_gemini_cli_command(scope: String) -> String:
	return "gemini mcp add --scope %s --transport http godot-mcp http://%s:%d/mcp" % [scope, settings.host, settings.port]


func _write_config_file(config_type: String, filepath: String, new_config: String, client_name: String) -> void:
	var json = JSON.new()
	if json.parse(new_config) != OK:
		_show_message(_tr("msg_parse_error"))
		return

	var new_config_data = json.get_data()
	var final_config: Dictionary = {}

	if FileAccess.file_exists(filepath):
		var file = FileAccess.open(filepath, FileAccess.READ)
		if file:
			var existing_text = file.get_as_text()
			file.close()
			if not existing_text.strip_edges().is_empty():
				if json.parse(existing_text) == OK:
					final_config = json.get_data()

	if final_config.has("mcpServers"):
		final_config["mcpServers"]["godot-mcp"] = new_config_data["mcpServers"]["godot-mcp"]
	else:
		final_config = new_config_data

	var dir_path = filepath.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir_path):
		var err = DirAccess.make_dir_recursive_absolute(dir_path)
		if err != OK:
			_show_message(_tr("msg_dir_error") + dir_path)
			return

	var file = FileAccess.open(filepath, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(final_config, "  "))
		file.close()
		_show_message(_tr("msg_config_success") % client_name)
		print("[Godot MCP] Config written to: %s" % filepath)
	else:
		_show_message(_tr("msg_write_error"))


func _show_message(message: String) -> void:
	print("[Godot MCP] %s" % message)
	var dialog = AcceptDialog.new()
	dialog.dialog_text = message
	dialog.title = "Godot MCP"
	if dock:
		dock.add_child(dialog)
		dialog.popup_centered()
		dialog.confirmed.connect(func(): dialog.queue_free())


func _copy_to_clipboard(text: String, source: String) -> void:
	DisplayServer.clipboard_set(text)
	_show_message(_tr("msg_copied") % source)


func _on_language_changed(index: int) -> void:
	var lang_code = _language_option.get_item_metadata(index)
	if _i18n:
		_i18n.set_language(lang_code)
		settings.language = lang_code
		_save_settings()
		# Rebuild UI to apply new language (use deferred to avoid crash)
		call_deferred("_rebuild_dock")


func _rebuild_dock() -> void:
	# Store current tab index
	var current_tab = 0
	if _tab_container:
		current_tab = _tab_container.current_tab

	# Clear UI references first
	_tab_container = null
	_status_label = null
	_status_indicator = null
	_port_spin = null
	_endpoint_label = null
	_conn_label = null
	_tool_list_container = null
	_tool_count_label = null
	_category_containers.clear()
	_tool_checkboxes.clear()
	_language_option = null
	_cli_scope_option = null
	_claude_cli_edit = null
	_codex_cli_edit = null
	_gemini_cli_edit = null

	# Remove old dock safely
	if dock and is_instance_valid(dock):
		remove_control_from_docks(dock)
		dock.queue_free()
		dock = null

	# Wait a frame before recreating
	await get_tree().process_frame

	# Recreate dock
	_create_dock()

	# Restore tab selection
	if _tab_container:
		_tab_container.current_tab = current_tab

	# Update UI
	call_deferred("_update_status_ui")
	call_deferred("_update_tool_count")


# Event handlers
func _on_server_started() -> void:
	_update_status_ui()


func _on_server_stopped() -> void:
	_update_status_ui()


func _on_start_pressed() -> void:
	if not mcp_server:
		return
	settings.port = int(_port_spin.value) if _port_spin else settings.port
	mcp_server.set_port(settings.port)
	mcp_server.start()
	_update_status_ui()
	_save_settings()


func _on_stop_pressed() -> void:
	if mcp_server:
		mcp_server.stop()
	_update_status_ui()


func _on_port_changed(value: float) -> void:
	settings.port = int(value)
	_update_status_ui()
	_save_settings()


func _on_auto_start_toggled(pressed: bool) -> void:
	settings.auto_start = pressed
	_save_settings()


func _on_debug_toggled(pressed: bool) -> void:
	settings.debug_mode = pressed
	if mcp_server:
		mcp_server.set_debug_mode(pressed)
	_save_settings()


func _on_tool_toggled(tool_name: String, enabled: bool) -> void:
	if enabled:
		settings.disabled_tools.erase(tool_name)
	else:
		if not tool_name in settings.disabled_tools:
			settings.disabled_tools.append(tool_name)

	if mcp_server:
		mcp_server.set_disabled_tools(settings.disabled_tools)

	var category = tool_name.split("_")[0] if "_" in tool_name else tool_name
	_update_category_count(category)
	_update_tool_count()
	_save_settings()


func _on_category_toggled(category: String, enabled: bool) -> void:
	if not _category_containers.has(category):
		return

	# Toggle all tools in this category using _tool_checkboxes
	for tool_name in _tool_checkboxes:
		if tool_name.begins_with(category + "_"):
			_tool_checkboxes[tool_name].set_pressed_no_signal(enabled)
			if enabled:
				settings.disabled_tools.erase(tool_name)
			else:
				if not tool_name in settings.disabled_tools:
					settings.disabled_tools.append(tool_name)

	if mcp_server:
		mcp_server.set_disabled_tools(settings.disabled_tools)

	_update_category_count(category)
	_update_tool_count()
	_save_settings()


func _on_category_collapse_toggled(category: String) -> void:
	if not _category_containers.has(category):
		return

	var container = _category_containers[category]
	var tools_margin = container["tools_margin"] as MarginContainer
	var toggle_btn = container["toggle_btn"] as Button

	var is_collapsed = category in settings.collapsed_categories

	if is_collapsed:
		# Expand
		settings.collapsed_categories.erase(category)
		tools_margin.visible = true
		toggle_btn.text = "▼"
	else:
		# Collapse
		settings.collapsed_categories.append(category)
		tools_margin.visible = false
		toggle_btn.text = "▶"

	_save_settings()


func _on_expand_all_categories() -> void:
	settings.collapsed_categories.clear()

	for category in _category_containers:
		var container = _category_containers[category]
		var tools_margin = container["tools_margin"] as MarginContainer
		var toggle_btn = container["toggle_btn"] as Button
		tools_margin.visible = true
		toggle_btn.text = "▼"

	_save_settings()


func _on_collapse_all_categories() -> void:
	settings.collapsed_categories.clear()

	for category in _category_containers:
		settings.collapsed_categories.append(category)
		var container = _category_containers[category]
		var tools_margin = container["tools_margin"] as MarginContainer
		var toggle_btn = container["toggle_btn"] as Button
		tools_margin.visible = false
		toggle_btn.text = "▶"

	_save_settings()


func _on_select_all_tools() -> void:
	settings.disabled_tools.clear()

	for tool_name in _tool_checkboxes:
		_tool_checkboxes[tool_name].set_pressed_no_signal(true)

	for category in _category_containers:
		_category_containers[category]["checkbox"].set_pressed_no_signal(true)
		_update_category_count(category)

	if mcp_server:
		mcp_server.set_disabled_tools(settings.disabled_tools)

	_update_tool_count()
	_save_settings()


func _on_deselect_all_tools() -> void:
	for tool_name in _tool_checkboxes:
		_tool_checkboxes[tool_name].set_pressed_no_signal(false)
		if not tool_name in settings.disabled_tools:
			settings.disabled_tools.append(tool_name)

	for category in _category_containers:
		_category_containers[category]["checkbox"].set_pressed_no_signal(false)
		_update_category_count(category)

	if mcp_server:
		mcp_server.set_disabled_tools(settings.disabled_tools)

	_update_tool_count()
	_save_settings()


# Settings persistence
func _load_settings() -> void:
	if FileAccess.file_exists(SETTINGS_PATH):
		var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		if file:
			var json = JSON.new()
			if json.parse(file.get_as_text()) == OK:
				var data = json.get_data()
				if data is Dictionary:
					settings.merge(data, true)
			file.close()


func _save_settings() -> void:
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(settings, "\t"))
		file.close()


# Public API
func get_server() -> MCPServer:
	return mcp_server


func start_server() -> void:
	_on_start_pressed()


func stop_server() -> void:
	_on_stop_pressed()
