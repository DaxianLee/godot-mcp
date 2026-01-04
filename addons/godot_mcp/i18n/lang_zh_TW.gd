@tool
extends RefCounted

## 繁體中文翻譯

const TRANSLATIONS: Dictionary = {
	# Tab names
	"tab_server": "伺服器",
	"tab_tools": "工具",
	"tab_config": "配置",

	# Header
	"title": "Godot MCP Server",
	"status_running": "執行中",
	"status_stopped": "已停止",

	# Server tab
	"server_status": "伺服器狀態",
	"endpoint": "端點位址:",
	"connections": "連線數:",
	"settings": "設定",
	"port": "連接埠:",
	"auto_start": "自動啟動",
	"debug_log": "除錯日誌",
	"btn_start": "啟動",
	"btn_stop": "停止",

	# About section
	"about": "關於",
	"author": "作者:",
	"wechat": "微信:",

	# Tools tab
	"tools_enabled": "工具: %d/%d 已啟用",
	"btn_expand_all": "全部展開",
	"btn_collapse_all": "全部摺疊",
	"btn_select_all": "全選",
	"btn_deselect_all": "全不選",

	# Tool categories - Core
	"cat_scene": "場景",
	"cat_node": "節點",
	"cat_script": "腳本",
	"cat_resource": "資源",
	"cat_filesystem": "檔案系統",
	"cat_project": "專案",
	"cat_editor": "編輯器",
	"cat_debug": "除錯",
	"cat_animation": "動畫",

	# Tool categories - Visual
	"cat_material": "材質",
	"cat_shader": "著色器",
	"cat_lighting": "燈光",
	"cat_particle": "粒子",

	# Tool categories - 2D
	"cat_tilemap": "圖塊地圖",
	"cat_geometry": "幾何體",

	# Tool categories - Gameplay
	"cat_physics": "物理",
	"cat_navigation": "導航",
	"cat_audio": "音訊",

	# Tool categories - Utilities
	"cat_ui": "使用者介面",
	"cat_signal": "訊號",
	"cat_group": "群組",

	# Config tab - IDE section
	"ide_config": "IDE 一鍵配置",
	"ide_config_desc": "點擊自動寫入配置檔案，重啟客戶端生效",
	"btn_one_click": "一鍵配置",
	"btn_copy": "複製",

	# Config tab - CLI section
	"cli_config": "CLI 命令列配置",
	"cli_config_desc": "複製命令在終端機中執行",
	"config_scope": "配置範圍:",
	"scope_user": "使用者級 (全域生效)",
	"scope_project": "專案級 (僅當前專案)",
	"btn_copy_cmd": "複製命令",

	# Messages
	"msg_config_success": "%s 配置成功!",
	"msg_config_failed": "配置失敗",
	"msg_copied": "%s 已複製到剪貼簿",
	"msg_parse_error": "配置解析失敗",
	"msg_dir_error": "無法建立目錄: ",
	"msg_write_error": "無法寫入配置檔案",

	# Language
	"language": "語言:",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
