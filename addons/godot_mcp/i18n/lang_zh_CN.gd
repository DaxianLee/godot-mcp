@tool
extends RefCounted

## 简体中文翻译

const TRANSLATIONS: Dictionary = {
	# Tab names
	"tab_server": "服务器",
	"tab_tools": "工具",
	"tab_config": "配置",

	# Header
	"title": "Godot MCP Server",
	"status_running": "运行中",
	"status_stopped": "已停止",

	# Server tab
	"server_status": "服务器状态",
	"endpoint": "端点地址:",
	"connections": "连接数:",
	"settings": "设置",
	"port": "端口:",
	"auto_start": "自动启动",
	"debug_log": "调试日志",
	"btn_start": "启动",
	"btn_stop": "停止",

	# About section
	"about": "关于",
	"author": "作者:",
	"wechat": "微信:",

	# Tools tab
	"tools_enabled": "工具: %d/%d 已启用",
	"btn_expand_all": "全部展开",
	"btn_collapse_all": "全部折叠",
	"btn_select_all": "全选",
	"btn_deselect_all": "全不选",

	# Tool categories - Core
	"cat_scene": "场景",
	"cat_node": "节点",
	"cat_script": "脚本",
	"cat_resource": "资源",
	"cat_filesystem": "文件系统",
	"cat_project": "项目",
	"cat_editor": "编辑器",
	"cat_debug": "调试",
	"cat_animation": "动画",

	# Tool categories - Visual
	"cat_material": "材质",
	"cat_shader": "着色器",
	"cat_lighting": "灯光",
	"cat_particle": "粒子",

	# Tool categories - 2D
	"cat_tilemap": "瓦片地图",
	"cat_geometry": "几何体",

	# Tool categories - Gameplay
	"cat_physics": "物理",
	"cat_navigation": "导航",
	"cat_audio": "音频",

	# Tool categories - Utilities
	"cat_ui": "用户界面",
	"cat_signal": "信号",
	"cat_group": "分组",

	# Config tab - IDE section
	"ide_config": "IDE 一键配置",
	"ide_config_desc": "点击自动写入配置文件，重启客户端生效",
	"btn_one_click": "一键配置",
	"btn_copy": "复制",

	# Config tab - CLI section
	"cli_config": "CLI 命令行配置",
	"cli_config_desc": "复制命令在终端中运行",
	"config_scope": "配置范围:",
	"scope_user": "用户级 (全局生效)",
	"scope_project": "项目级 (仅当前项目)",
	"btn_copy_cmd": "复制命令",

	# Messages
	"msg_config_success": "%s 配置成功!",
	"msg_config_failed": "配置失败",
	"msg_copied": "%s 已复制到剪贴板",
	"msg_parse_error": "配置解析失败",
	"msg_dir_error": "无法创建目录: ",
	"msg_write_error": "无法写入配置文件",

	# Language
	"language": "语言:",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
