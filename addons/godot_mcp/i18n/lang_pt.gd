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
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
