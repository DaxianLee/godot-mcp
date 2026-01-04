@tool
extends RefCounted

## Русский перевод

const TRANSLATIONS: Dictionary = {
	# Tab names
	"tab_server": "Сервер",
	"tab_tools": "Инструменты",
	"tab_config": "Настройки",

	# Header
	"title": "Godot MCP Server",
	"status_running": "Работает",
	"status_stopped": "Остановлен",

	# Server tab
	"server_status": "Состояние сервера",
	"endpoint": "Адрес:",
	"connections": "Подключения:",
	"settings": "Настройки",
	"port": "Порт:",
	"auto_start": "Автозапуск",
	"debug_log": "Журнал отладки",
	"btn_start": "Запустить",
	"btn_stop": "Остановить",

	# About section
	"about": "О программе",
	"author": "Автор:",
	"wechat": "WeChat:",

	# Tools tab
	"tools_enabled": "Инструменты: %d/%d включено",
	"btn_expand_all": "Развернуть все",
	"btn_collapse_all": "Свернуть все",
	"btn_select_all": "Выбрать все",
	"btn_deselect_all": "Снять все",

	# Tool categories - Core
	"cat_scene": "Сцена",
	"cat_node": "Узел",
	"cat_script": "Скрипт",
	"cat_resource": "Ресурс",
	"cat_filesystem": "Файловая система",
	"cat_project": "Проект",
	"cat_editor": "Редактор",
	"cat_debug": "Отладка",
	"cat_animation": "Анимация",

	# Tool categories - Visual
	"cat_material": "Материал",
	"cat_shader": "Шейдер",
	"cat_lighting": "Освещение",
	"cat_particle": "Частицы",

	# Tool categories - 2D
	"cat_tilemap": "Тайлмап",
	"cat_geometry": "Геометрия",

	# Tool categories - Gameplay
	"cat_physics": "Физика",
	"cat_navigation": "Навигация",
	"cat_audio": "Аудио",

	# Tool categories - Utilities
	"cat_ui": "Интерфейс",
	"cat_signal": "Сигнал",
	"cat_group": "Группа",

	# Config tab - IDE section
	"ide_config": "Настройка IDE в один клик",
	"ide_config_desc": "Нажмите для автоматической записи конфигурации, перезапустите клиент",
	"btn_one_click": "Настроить",
	"btn_copy": "Копировать",

	# Config tab - CLI section
	"cli_config": "Настройка командной строки",
	"cli_config_desc": "Скопируйте команду и выполните в терминале",
	"config_scope": "Область настройки:",
	"scope_user": "Пользователь (глобально)",
	"scope_project": "Проект (только текущий)",
	"btn_copy_cmd": "Копировать команду",

	# Messages
	"msg_config_success": "%s настроен успешно!",
	"msg_config_failed": "Ошибка настройки",
	"msg_copied": "%s скопировано в буфер обмена",
	"msg_parse_error": "Ошибка разбора конфигурации",
	"msg_dir_error": "Невозможно создать каталог: ",
	"msg_write_error": "Невозможно записать файл конфигурации",

	# Language
	"language": "Язык:",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
