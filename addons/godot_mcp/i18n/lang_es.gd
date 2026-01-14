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

	# ==================== Descripciones de herramientas ====================
	# Herramientas de escena
	"tool_scene_management_desc": "Abrir, guardar, crear y gestionar escenas",
	"tool_scene_hierarchy_desc": "Obtener estructura del árbol de escena y selección de nodos",
	"tool_scene_run_desc": "Ejecutar y probar escenas en el editor",

	# Herramientas de nodo
	"tool_node_query_desc": "Buscar e inspeccionar nodos por nombre, tipo o patrón",
	"tool_node_lifecycle_desc": "Crear, eliminar, duplicar e instanciar nodos",
	"tool_node_transform_desc": "Modificar posición, rotación y escala",
	"tool_node_property_desc": "Obtener y establecer cualquier propiedad de nodo",
	"tool_node_hierarchy_desc": "Gestionar relaciones padre-hijo y orden",
	"tool_node_signal_desc": "Conectar, desconectar y emitir señales",
	"tool_node_group_desc": "Añadir, eliminar y consultar grupos de nodos",
	"tool_node_process_desc": "Controlar modos de procesamiento de nodos",
	"tool_node_metadata_desc": "Obtener y establecer metadatos del nodo",
	"tool_node_call_desc": "Llamar dinámicamente métodos en nodos",
	"tool_node_visibility_desc": "Controlar visibilidad y capas de nodos",
	"tool_node_physics_desc": "Configurar propiedades físicas",

	# Herramientas de recurso
	"tool_resource_query_desc": "Buscar e inspeccionar recursos",
	"tool_resource_manage_desc": "Cargar, guardar y duplicar recursos",
	"tool_resource_texture_desc": "Gestionar recursos de textura",

	# Herramientas de proyecto
	"tool_project_info_desc": "Obtener información y rutas del proyecto",
	"tool_project_settings_desc": "Leer y modificar ajustes del proyecto",
	"tool_project_input_desc": "Gestionar mapeos de acciones de entrada",
	"tool_project_autoload_desc": "Gestionar singletons de autocarga",

	# Herramientas de script
	"tool_script_manage_desc": "Crear, leer y modificar scripts",
	"tool_script_attach_desc": "Adjuntar o separar scripts de nodos",
	"tool_script_edit_desc": "Añadir funciones, variables y señales",
	"tool_script_open_desc": "Abrir scripts en el editor",

	# Herramientas de editor
	"tool_editor_status_desc": "Obtener estado del editor e información de escena",
	"tool_editor_settings_desc": "Leer y modificar ajustes del editor",
	"tool_editor_undo_redo_desc": "Gestionar operaciones deshacer/rehacer",
	"tool_editor_notification_desc": "Mostrar notificaciones y diálogos del editor",
	"tool_editor_inspector_desc": "Controlar el panel inspector",
	"tool_editor_filesystem_desc": "Interactuar con el dock del sistema de archivos",
	"tool_editor_plugin_desc": "Buscar y gestionar plugins del editor",

	# Herramientas de depuración
	"tool_debug_log_desc": "Imprimir mensajes de depuración y errores",
	"tool_debug_performance_desc": "Monitorizar métricas de rendimiento",
	"tool_debug_profiler_desc": "Perfilar ejecución de código",
	"tool_debug_class_db_desc": "Consultar base de datos de clases de Godot",

	# Herramientas del sistema de archivos
	"tool_filesystem_directory_desc": "Crear, eliminar y listar directorios",
	"tool_filesystem_file_desc": "Leer, escribir y gestionar archivos",
	"tool_filesystem_json_desc": "Leer y escribir archivos JSON",
	"tool_filesystem_search_desc": "Buscar archivos por patrón",

	# Herramientas de animación
	"tool_animation_player_desc": "Controlar nodos AnimationPlayer",
	"tool_animation_animation_desc": "Crear y modificar animaciones",
	"tool_animation_track_desc": "Añadir y editar pistas de animación",
	"tool_animation_tween_desc": "Crear y controlar tweens",
	"tool_animation_animation_tree_desc": "Configurar árboles de animación",
	"tool_animation_state_machine_desc": "Gestionar máquinas de estados de animación",
	"tool_animation_blend_space_desc": "Configurar espacios de mezcla",
	"tool_animation_blend_tree_desc": "Configurar nodos de árbol de mezcla",

	# Herramientas de material
	"tool_material_material_desc": "Crear y modificar materiales",
	"tool_material_mesh_desc": "Gestionar recursos de malla",

	# Herramientas de shader
	"tool_shader_shader_desc": "Crear y editar shaders",
	"tool_shader_shader_material_desc": "Aplicar shaders a materiales",

	# Herramientas de iluminación
	"tool_lighting_light_desc": "Crear y configurar luces",
	"tool_lighting_environment_desc": "Configurar entorno mundial",
	"tool_lighting_sky_desc": "Configurar cielo y atmósfera",

	# Herramientas de partículas
	"tool_particle_particles_desc": "Crear y configurar sistemas de partículas",
	"tool_particle_particle_material_desc": "Configurar materiales de partículas",

	# Herramientas de tilemap
	"tool_tilemap_tileset_desc": "Crear y editar tilesets",
	"tool_tilemap_tilemap_desc": "Editar capas y celdas del tilemap",

	# Herramientas de geometría
	"tool_geometry_csg_desc": "Crear geometría sólida constructiva CSG",
	"tool_geometry_gridmap_desc": "Editar mapas de cuadrícula 3D",
	"tool_geometry_multimesh_desc": "Configurar instancias multi-malla",

	# Herramientas de física
	"tool_physics_physics_body_desc": "Crear y configurar cuerpos físicos",
	"tool_physics_collision_shape_desc": "Añadir y modificar formas de colisión",
	"tool_physics_physics_joint_desc": "Crear articulaciones y restricciones físicas",
	"tool_physics_physics_query_desc": "Realizar consultas físicas y raycasts",

	# Herramientas de navegación
	"tool_navigation_navigation_desc": "Configurar mallas y agentes de navegación",

	# Herramientas de audio
	"tool_audio_bus_desc": "Gestionar buses de audio y efectos",
	"tool_audio_player_desc": "Controlar reproducción de audio",

	# Herramientas de UI
	"tool_ui_theme_desc": "Crear y modificar temas de UI",
	"tool_ui_control_desc": "Configurar nodos de control",

	# Herramientas de señal
	"tool_signal_signal_desc": "Gestionar globalmente conexiones de señales",

	# Herramientas de grupo
	"tool_group_group_desc": "Buscar y gestionar globalmente grupos de nodos",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
