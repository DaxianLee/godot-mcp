@tool
extends RefCounted
class_name MCPLocalization

## MCP Server Localization Manager
## Easy to extend - just add new language files and register them

# Singleton instance
static var _instance: MCPLocalization = null

# Current language code
var _current_language: String = "en"

# Loaded translations
var _translations: Dictionary = {}

# Available languages with their display names
const AVAILABLE_LANGUAGES: Dictionary = {
	"en": "English",
	"zh_CN": "简体中文",
	"zh_TW": "繁體中文",
	"ja": "日本語",
	"ru": "Русский",
	"fr": "Français",
	"pt": "Português",
	"es": "Español",
	"de": "Deutsch"
}

# Language file mapping
const LANGUAGE_FILES: Dictionary = {
	"en": "res://addons/godot_mcp/i18n/lang_en.gd",
	"zh_CN": "res://addons/godot_mcp/i18n/lang_zh_CN.gd",
	"zh_TW": "res://addons/godot_mcp/i18n/lang_zh_TW.gd",
	"ja": "res://addons/godot_mcp/i18n/lang_ja.gd",
	"ru": "res://addons/godot_mcp/i18n/lang_ru.gd",
	"fr": "res://addons/godot_mcp/i18n/lang_fr.gd",
	"pt": "res://addons/godot_mcp/i18n/lang_pt.gd",
	"es": "res://addons/godot_mcp/i18n/lang_es.gd",
	"de": "res://addons/godot_mcp/i18n/lang_de.gd"
}


static func get_instance() -> MCPLocalization:
	if _instance == null:
		_instance = MCPLocalization.new()
		_instance._init_translations()
	return _instance


func _init_translations() -> void:
	# Load all language files
	for lang_code in LANGUAGE_FILES:
		var file_path = LANGUAGE_FILES[lang_code]
		if ResourceLoader.exists(file_path):
			var lang_script = load(file_path)
			if lang_script and lang_script.has_method("get_translations"):
				_translations[lang_code] = lang_script.get_translations()
			elif lang_script and "TRANSLATIONS" in lang_script:
				_translations[lang_code] = lang_script.TRANSLATIONS

	# Auto-detect language from system
	_current_language = _detect_system_language()


func _detect_system_language() -> String:
	var locale = OS.get_locale()

	# Check for exact match first
	if locale in AVAILABLE_LANGUAGES:
		return locale

	# Check for language code match (e.g., "zh" matches "zh_CN")
	var lang_code = locale.split("_")[0]

	match lang_code:
		"zh":
			# Detect Traditional vs Simplified Chinese
			if locale.to_lower().contains("tw") or locale.to_lower().contains("hk") or locale.to_lower().contains("hant"):
				return "zh_TW"
			return "zh_CN"
		"ja":
			return "ja"
		"ru":
			return "ru"
		"fr":
			return "fr"
		"pt":
			return "pt"
		"es":
			return "es"
		"de":
			return "de"
		_:
			return "en"


func set_language(lang_code: String) -> void:
	if lang_code in AVAILABLE_LANGUAGES:
		_current_language = lang_code


func get_language() -> String:
	return _current_language


func get_available_languages() -> Dictionary:
	return AVAILABLE_LANGUAGES


func get_text(key: String) -> String:
	"""Translate a key to current language"""
	# Try current language
	if _current_language in _translations:
		var trans = _translations[_current_language]
		if key in trans:
			return trans[key]

	# Fallback to English
	if "en" in _translations:
		var en_trans = _translations["en"]
		if key in en_trans:
			return en_trans[key]

	# Return key if no translation found
	return key


# Convenience static method
static func translate(key: String) -> String:
	return get_instance().get_text(key)
