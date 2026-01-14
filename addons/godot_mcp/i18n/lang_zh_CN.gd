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

	# ==================== 工具描述 ====================
	# 场景工具
	"tool_scene_management_desc": "打开、保存、创建和管理场景",
	"tool_scene_hierarchy_desc": "获取场景树结构和节点选择",
	"tool_scene_run_desc": "在编辑器中运行和测试场景",

	# 节点工具
	"tool_node_query_desc": "按名称、类型或模式查找和检查节点",
	"tool_node_lifecycle_desc": "创建、删除、复制和实例化节点",
	"tool_node_transform_desc": "修改位置、旋转和缩放",
	"tool_node_property_desc": "获取和设置任意节点属性",
	"tool_node_hierarchy_desc": "管理父子关系和节点顺序",
	"tool_node_signal_desc": "连接、断开和发射信号",
	"tool_node_group_desc": "添加、移除和查询节点分组",
	"tool_node_process_desc": "控制节点处理模式",
	"tool_node_metadata_desc": "获取和设置节点元数据",
	"tool_node_call_desc": "动态调用节点方法",
	"tool_node_visibility_desc": "控制节点可见性和图层",
	"tool_node_physics_desc": "配置物理属性",

	# 资源工具
	"tool_resource_query_desc": "查找和检查资源",
	"tool_resource_manage_desc": "加载、保存和复制资源",
	"tool_resource_texture_desc": "管理纹理资源",

	# 项目工具
	"tool_project_info_desc": "获取项目信息和路径",
	"tool_project_settings_desc": "读取和修改项目设置",
	"tool_project_input_desc": "管理输入动作映射",
	"tool_project_autoload_desc": "管理自动加载单例",

	# 脚本工具
	"tool_script_manage_desc": "创建、读取和修改脚本",
	"tool_script_attach_desc": "附加或分离节点脚本",
	"tool_script_edit_desc": "添加函数、变量和信号",
	"tool_script_open_desc": "在编辑器中打开脚本",

	# 编辑器工具
	"tool_editor_status_desc": "获取编辑器状态和场景信息",
	"tool_editor_settings_desc": "读取和修改编辑器设置",
	"tool_editor_undo_redo_desc": "管理撤销/重做操作",
	"tool_editor_notification_desc": "显示编辑器通知和对话框",
	"tool_editor_inspector_desc": "控制检视器面板",
	"tool_editor_filesystem_desc": "与文件系统面板交互",
	"tool_editor_plugin_desc": "查询和管理编辑器插件",

	# 调试工具
	"tool_debug_log_desc": "打印调试消息和错误",
	"tool_debug_performance_desc": "监控性能指标",
	"tool_debug_profiler_desc": "分析代码执行",
	"tool_debug_class_db_desc": "查询Godot类数据库",

	# 文件系统工具
	"tool_filesystem_directory_desc": "创建、删除和列出目录",
	"tool_filesystem_file_desc": "读取、写入和管理文件",
	"tool_filesystem_json_desc": "读写JSON文件",
	"tool_filesystem_search_desc": "按模式搜索文件",

	# 动画工具
	"tool_animation_player_desc": "控制AnimationPlayer节点",
	"tool_animation_animation_desc": "创建和修改动画",
	"tool_animation_track_desc": "添加和编辑动画轨道",
	"tool_animation_tween_desc": "创建和控制补间动画",
	"tool_animation_animation_tree_desc": "设置和配置动画树",
	"tool_animation_state_machine_desc": "管理动画状态机",
	"tool_animation_blend_space_desc": "配置混合空间",
	"tool_animation_blend_tree_desc": "设置混合树节点",

	# 材质工具
	"tool_material_material_desc": "创建和修改材质",
	"tool_material_mesh_desc": "管理网格资源",

	# 着色器工具
	"tool_shader_shader_desc": "创建和编辑着色器",
	"tool_shader_shader_material_desc": "将着色器应用到材质",

	# 灯光工具
	"tool_lighting_light_desc": "创建和配置灯光",
	"tool_lighting_environment_desc": "设置世界环境",
	"tool_lighting_sky_desc": "配置天空和大气",

	# 粒子工具
	"tool_particle_particles_desc": "创建和配置粒子系统",
	"tool_particle_particle_material_desc": "设置粒子材质",

	# 瓦片地图工具
	"tool_tilemap_tileset_desc": "创建和编辑瓦片集",
	"tool_tilemap_tilemap_desc": "编辑瓦片地图图层和单元格",

	# 几何体工具
	"tool_geometry_csg_desc": "创建CSG构造实体几何",
	"tool_geometry_gridmap_desc": "编辑3D网格地图",
	"tool_geometry_multimesh_desc": "设置多网格实例",

	# 物理工具
	"tool_physics_physics_body_desc": "创建和配置物理体",
	"tool_physics_collision_shape_desc": "添加和修改碰撞形状",
	"tool_physics_physics_joint_desc": "创建物理关节和约束",
	"tool_physics_physics_query_desc": "执行物理查询和射线检测",

	# 导航工具
	"tool_navigation_navigation_desc": "设置导航网格和代理",

	# 音频工具
	"tool_audio_bus_desc": "管理音频总线和效果",
	"tool_audio_player_desc": "控制音频播放",

	# UI工具
	"tool_ui_theme_desc": "创建和修改UI主题",
	"tool_ui_control_desc": "配置控件节点",

	# 信号工具
	"tool_signal_signal_desc": "全局管理信号连接",

	# 分组工具
	"tool_group_group_desc": "全局查询和管理节点分组",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
