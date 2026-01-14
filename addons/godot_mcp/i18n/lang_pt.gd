@tool
extends RefCounted

## Tradução em português

const TRANSLATIONS: Dictionary = {
	# Tab names
	"tab_server": "Servidor",
	"tab_tools": "Ferramentas",
	"tab_config": "Config",

	# Header
	"title": "Godot MCP Server",
	"status_running": "Executando",
	"status_stopped": "Parado",

	# Server tab
	"server_status": "Estado do servidor",
	"endpoint": "Endpoint:",
	"connections": "Conexões:",
	"settings": "Configurações",
	"port": "Porta:",
	"auto_start": "Início automático",
	"debug_log": "Log de depuração",
	"btn_start": "Iniciar",
	"btn_stop": "Parar",

	# About section
	"about": "Sobre",
	"author": "Autor:",
	"wechat": "WeChat:",

	# Tools tab
	"tools_enabled": "Ferramentas: %d/%d ativadas",
	"btn_expand_all": "Expandir tudo",
	"btn_collapse_all": "Recolher tudo",
	"btn_select_all": "Selecionar tudo",
	"btn_deselect_all": "Desmarcar tudo",

	# Tool categories - Core
	"cat_scene": "Cena",
	"cat_node": "Nó",
	"cat_script": "Script",
	"cat_resource": "Recurso",
	"cat_filesystem": "Sistema de arquivos",
	"cat_project": "Projeto",
	"cat_editor": "Editor",
	"cat_debug": "Depuração",
	"cat_animation": "Animação",

	# Tool categories - Visual
	"cat_material": "Material",
	"cat_shader": "Shader",
	"cat_lighting": "Iluminação",
	"cat_particle": "Partícula",

	# Tool categories - 2D
	"cat_tilemap": "TileMap",
	"cat_geometry": "Geometria",

	# Tool categories - Gameplay
	"cat_physics": "Física",
	"cat_navigation": "Navegação",
	"cat_audio": "Áudio",

	# Tool categories - Utilities
	"cat_ui": "Interface",
	"cat_signal": "Sinal",
	"cat_group": "Grupo",

	# Config tab - IDE section
	"ide_config": "Configuração IDE com um clique",
	"ide_config_desc": "Clique para gravar automaticamente o arquivo de config, reinicie o cliente",
	"btn_one_click": "Configurar",
	"btn_copy": "Copiar",

	# Config tab - CLI section
	"cli_config": "Configuração de linha de comando",
	"cli_config_desc": "Copie o comando e execute no terminal",
	"config_scope": "Escopo da config:",
	"scope_user": "Usuário (global)",
	"scope_project": "Projeto (apenas atual)",
	"btn_copy_cmd": "Copiar comando",

	# Messages
	"msg_config_success": "%s configurado com sucesso!",
	"msg_config_failed": "Falha na configuração",
	"msg_copied": "%s copiado para a área de transferência",
	"msg_parse_error": "Erro ao analisar configuração",
	"msg_dir_error": "Não foi possível criar o diretório: ",
	"msg_write_error": "Não foi possível gravar o arquivo de configuração",

	# Language
	"language": "Idioma:",

	# ==================== Descrições das ferramentas ====================
	# Ferramentas de cena
	"tool_scene_management_desc": "Abrir, salvar, criar e gerenciar cenas",
	"tool_scene_hierarchy_desc": "Obter estrutura da árvore de cena e seleção de nós",
	"tool_scene_run_desc": "Executar e testar cenas no editor",

	# Ferramentas de nó
	"tool_node_query_desc": "Buscar e inspecionar nós por nome, tipo ou padrão",
	"tool_node_lifecycle_desc": "Criar, excluir, duplicar e instanciar nós",
	"tool_node_transform_desc": "Modificar posição, rotação e escala",
	"tool_node_property_desc": "Obter e definir qualquer propriedade do nó",
	"tool_node_hierarchy_desc": "Gerenciar relações pai-filho e ordem",
	"tool_node_signal_desc": "Conectar, desconectar e emitir sinais",
	"tool_node_group_desc": "Adicionar, remover e consultar grupos de nós",
	"tool_node_process_desc": "Controlar modos de processamento de nós",
	"tool_node_metadata_desc": "Obter e definir metadados do nó",
	"tool_node_call_desc": "Chamar dinamicamente métodos em nós",
	"tool_node_visibility_desc": "Controlar visibilidade e camadas de nós",
	"tool_node_physics_desc": "Configurar propriedades físicas",

	# Ferramentas de recurso
	"tool_resource_query_desc": "Buscar e inspecionar recursos",
	"tool_resource_manage_desc": "Carregar, salvar e duplicar recursos",
	"tool_resource_texture_desc": "Gerenciar recursos de textura",

	# Ferramentas de projeto
	"tool_project_info_desc": "Obter informações e caminhos do projeto",
	"tool_project_settings_desc": "Ler e modificar configurações do projeto",
	"tool_project_input_desc": "Gerenciar mapeamentos de ações de entrada",
	"tool_project_autoload_desc": "Gerenciar singletons de autoload",

	# Ferramentas de script
	"tool_script_manage_desc": "Criar, ler e modificar scripts",
	"tool_script_attach_desc": "Anexar ou desanexar scripts de nós",
	"tool_script_edit_desc": "Adicionar funções, variáveis e sinais",
	"tool_script_open_desc": "Abrir scripts no editor",

	# Ferramentas de editor
	"tool_editor_status_desc": "Obter status do editor e informações da cena",
	"tool_editor_settings_desc": "Ler e modificar configurações do editor",
	"tool_editor_undo_redo_desc": "Gerenciar operações desfazer/refazer",
	"tool_editor_notification_desc": "Exibir notificações e diálogos do editor",
	"tool_editor_inspector_desc": "Controlar o painel inspetor",
	"tool_editor_filesystem_desc": "Interagir com o dock do sistema de arquivos",
	"tool_editor_plugin_desc": "Buscar e gerenciar plugins do editor",

	# Ferramentas de depuração
	"tool_debug_log_desc": "Imprimir mensagens de depuração e erros",
	"tool_debug_performance_desc": "Monitorar métricas de desempenho",
	"tool_debug_profiler_desc": "Perfilar execução de código",
	"tool_debug_class_db_desc": "Consultar banco de dados de classes do Godot",

	# Ferramentas do sistema de arquivos
	"tool_filesystem_directory_desc": "Criar, excluir e listar diretórios",
	"tool_filesystem_file_desc": "Ler, escrever e gerenciar arquivos",
	"tool_filesystem_json_desc": "Ler e escrever arquivos JSON",
	"tool_filesystem_search_desc": "Buscar arquivos por padrão",

	# Ferramentas de animação
	"tool_animation_player_desc": "Controlar nós AnimationPlayer",
	"tool_animation_animation_desc": "Criar e modificar animações",
	"tool_animation_track_desc": "Adicionar e editar trilhas de animação",
	"tool_animation_tween_desc": "Criar e controlar tweens",
	"tool_animation_animation_tree_desc": "Configurar árvores de animação",
	"tool_animation_state_machine_desc": "Gerenciar máquinas de estados de animação",
	"tool_animation_blend_space_desc": "Configurar espaços de mistura",
	"tool_animation_blend_tree_desc": "Configurar nós de árvore de mistura",

	# Ferramentas de material
	"tool_material_material_desc": "Criar e modificar materiais",
	"tool_material_mesh_desc": "Gerenciar recursos de malha",

	# Ferramentas de shader
	"tool_shader_shader_desc": "Criar e editar shaders",
	"tool_shader_shader_material_desc": "Aplicar shaders a materiais",

	# Ferramentas de iluminação
	"tool_lighting_light_desc": "Criar e configurar luzes",
	"tool_lighting_environment_desc": "Configurar ambiente mundial",
	"tool_lighting_sky_desc": "Configurar céu e atmosfera",

	# Ferramentas de partículas
	"tool_particle_particles_desc": "Criar e configurar sistemas de partículas",
	"tool_particle_particle_material_desc": "Configurar materiais de partículas",

	# Ferramentas de tilemap
	"tool_tilemap_tileset_desc": "Criar e editar tilesets",
	"tool_tilemap_tilemap_desc": "Editar camadas e células do tilemap",

	# Ferramentas de geometria
	"tool_geometry_csg_desc": "Criar geometria sólida construtiva CSG",
	"tool_geometry_gridmap_desc": "Editar mapas de grade 3D",
	"tool_geometry_multimesh_desc": "Configurar instâncias multi-malha",

	# Ferramentas de física
	"tool_physics_physics_body_desc": "Criar e configurar corpos físicos",
	"tool_physics_collision_shape_desc": "Adicionar e modificar formas de colisão",
	"tool_physics_physics_joint_desc": "Criar juntas e restrições físicas",
	"tool_physics_physics_query_desc": "Realizar consultas físicas e raycasts",

	# Ferramentas de navegação
	"tool_navigation_navigation_desc": "Configurar malhas e agentes de navegação",

	# Ferramentas de áudio
	"tool_audio_bus_desc": "Gerenciar buses de áudio e efeitos",
	"tool_audio_player_desc": "Controlar reprodução de áudio",

	# Ferramentas de UI
	"tool_ui_theme_desc": "Criar e modificar temas de UI",
	"tool_ui_control_desc": "Configurar nós de controle",

	# Ferramentas de sinal
	"tool_signal_signal_desc": "Gerenciar globalmente conexões de sinais",

	# Ferramentas de grupo
	"tool_group_group_desc": "Buscar e gerenciar globalmente grupos de nós",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
