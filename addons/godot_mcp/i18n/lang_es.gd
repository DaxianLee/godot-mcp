@tool
extends RefCounted

## Traducción al español

const TRANSLATIONS: Dictionary = {
	# Tab names
	"tab_server": "Servidor",
	"tab_tools": "Herramientas",
	"tab_config": "Config",

	# Header
	"title": "Godot MCP Server",
	"status_running": "Ejecutando",
	"status_stopped": "Detenido",

	# Server tab
	"server_status": "Estado del servidor",
	"endpoint": "Punto final:",
	"connections": "Conexiones:",
	"settings": "Ajustes",
	"port": "Puerto:",
	"auto_start": "Inicio automático",
	"debug_log": "Registro de depuración",
	"btn_start": "Iniciar",
	"btn_stop": "Detener",

	# About section
	"about": "Acerca de",
	"author": "Autor:",
	"wechat": "WeChat:",

	# Tools tab
	"tools_enabled": "Herramientas: %d/%d habilitadas",
	"btn_expand_all": "Expandir todo",
	"btn_collapse_all": "Contraer todo",
	"btn_select_all": "Seleccionar todo",
	"btn_deselect_all": "Deseleccionar todo",

	# Tool categories - Core
	"cat_scene": "Escena",
	"cat_node": "Nodo",
	"cat_script": "Script",
	"cat_resource": "Recurso",
	"cat_filesystem": "Sistema de archivos",
	"cat_project": "Proyecto",
	"cat_editor": "Editor",
	"cat_debug": "Depuración",
	"cat_animation": "Animación",

	# Tool categories - Visual
	"cat_material": "Material",
	"cat_shader": "Shader",
	"cat_lighting": "Iluminación",
	"cat_particle": "Partícula",

	# Tool categories - 2D
	"cat_tilemap": "TileMap",
	"cat_geometry": "Geometría",

	# Tool categories - Gameplay
	"cat_physics": "Física",
	"cat_navigation": "Navegación",
	"cat_audio": "Audio",

	# Tool categories - Utilities
	"cat_ui": "Interfaz",
	"cat_signal": "Señal",
	"cat_group": "Grupo",

	# Config tab - IDE section
	"ide_config": "Configuración IDE con un clic",
	"ide_config_desc": "Haga clic para escribir automáticamente el archivo de config, reinicie el cliente",
	"btn_one_click": "Configurar",
	"btn_copy": "Copiar",

	# Config tab - CLI section
	"cli_config": "Configuración de línea de comandos",
	"cli_config_desc": "Copie el comando y ejecútelo en la terminal",
	"config_scope": "Ámbito de config:",
	"scope_user": "Usuario (global)",
	"scope_project": "Proyecto (solo actual)",
	"btn_copy_cmd": "Copiar comando",

	# Messages
	"msg_config_success": "¡%s configurado con éxito!",
	"msg_config_failed": "Error de configuración",
	"msg_copied": "%s copiado al portapapeles",
	"msg_parse_error": "Error al analizar la configuración",
	"msg_dir_error": "No se puede crear el directorio: ",
	"msg_write_error": "No se puede escribir el archivo de configuración",

	# Language
	"language": "Idioma:",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
