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

	# ==================== 工具描述 ====================
	# 場景工具
	"tool_scene_management_desc": "開啟、儲存、建立和管理場景",
	"tool_scene_hierarchy_desc": "取得場景樹結構和節點選擇",
	"tool_scene_run_desc": "在編輯器中執行和測試場景",

	# 節點工具
	"tool_node_query_desc": "按名稱、類型或模式尋找和檢查節點",
	"tool_node_lifecycle_desc": "建立、刪除、複製和實例化節點",
	"tool_node_transform_desc": "修改位置、旋轉和縮放",
	"tool_node_property_desc": "取得和設定任意節點屬性",
	"tool_node_hierarchy_desc": "管理父子關係和節點順序",
	"tool_node_signal_desc": "連接、斷開和發射訊號",
	"tool_node_group_desc": "新增、移除和查詢節點群組",
	"tool_node_process_desc": "控制節點處理模式",
	"tool_node_metadata_desc": "取得和設定節點元資料",
	"tool_node_call_desc": "動態呼叫節點方法",
	"tool_node_visibility_desc": "控制節點可見性和圖層",
	"tool_node_physics_desc": "配置物理屬性",

	# 資源工具
	"tool_resource_query_desc": "尋找和檢查資源",
	"tool_resource_manage_desc": "載入、儲存和複製資源",
	"tool_resource_texture_desc": "管理紋理資源",

	# 專案工具
	"tool_project_info_desc": "取得專案資訊和路徑",
	"tool_project_settings_desc": "讀取和修改專案設定",
	"tool_project_input_desc": "管理輸入動作映射",
	"tool_project_autoload_desc": "管理自動載入單例",

	# 腳本工具
	"tool_script_manage_desc": "建立、讀取和修改腳本",
	"tool_script_attach_desc": "附加或分離節點腳本",
	"tool_script_edit_desc": "新增函式、變數和訊號",
	"tool_script_open_desc": "在編輯器中開啟腳本",

	# 編輯器工具
	"tool_editor_status_desc": "取得編輯器狀態和場景資訊",
	"tool_editor_settings_desc": "讀取和修改編輯器設定",
	"tool_editor_undo_redo_desc": "管理復原/重做操作",
	"tool_editor_notification_desc": "顯示編輯器通知和對話框",
	"tool_editor_inspector_desc": "控制檢視器面板",
	"tool_editor_filesystem_desc": "與檔案系統面板互動",
	"tool_editor_plugin_desc": "查詢和管理編輯器外掛程式",

	# 除錯工具
	"tool_debug_log_desc": "列印除錯訊息和錯誤",
	"tool_debug_performance_desc": "監控效能指標",
	"tool_debug_profiler_desc": "分析程式碼執行",
	"tool_debug_class_db_desc": "查詢Godot類別資料庫",

	# 檔案系統工具
	"tool_filesystem_directory_desc": "建立、刪除和列出目錄",
	"tool_filesystem_file_desc": "讀取、寫入和管理檔案",
	"tool_filesystem_json_desc": "讀寫JSON檔案",
	"tool_filesystem_search_desc": "按模式搜尋檔案",

	# 動畫工具
	"tool_animation_player_desc": "控制AnimationPlayer節點",
	"tool_animation_animation_desc": "建立和修改動畫",
	"tool_animation_track_desc": "新增和編輯動畫軌道",
	"tool_animation_tween_desc": "建立和控制補間動畫",
	"tool_animation_animation_tree_desc": "設定和配置動畫樹",
	"tool_animation_state_machine_desc": "管理動畫狀態機",
	"tool_animation_blend_space_desc": "配置混合空間",
	"tool_animation_blend_tree_desc": "設定混合樹節點",

	# 材質工具
	"tool_material_material_desc": "建立和修改材質",
	"tool_material_mesh_desc": "管理網格資源",

	# 著色器工具
	"tool_shader_shader_desc": "建立和編輯著色器",
	"tool_shader_shader_material_desc": "將著色器套用到材質",

	# 燈光工具
	"tool_lighting_light_desc": "建立和配置燈光",
	"tool_lighting_environment_desc": "設定世界環境",
	"tool_lighting_sky_desc": "配置天空和大氣",

	# 粒子工具
	"tool_particle_particles_desc": "建立和配置粒子系統",
	"tool_particle_particle_material_desc": "設定粒子材質",

	# 圖塊地圖工具
	"tool_tilemap_tileset_desc": "建立和編輯圖塊集",
	"tool_tilemap_tilemap_desc": "編輯圖塊地圖圖層和單元格",

	# 幾何體工具
	"tool_geometry_csg_desc": "建立CSG構造實體幾何",
	"tool_geometry_gridmap_desc": "編輯3D網格地圖",
	"tool_geometry_multimesh_desc": "設定多網格實例",

	# 物理工具
	"tool_physics_physics_body_desc": "建立和配置物理體",
	"tool_physics_collision_shape_desc": "新增和修改碰撞形狀",
	"tool_physics_physics_joint_desc": "建立物理關節和約束",
	"tool_physics_physics_query_desc": "執行物理查詢和射線檢測",

	# 導航工具
	"tool_navigation_navigation_desc": "設定導航網格和代理",

	# 音訊工具
	"tool_audio_bus_desc": "管理音訊匯流排和效果",
	"tool_audio_player_desc": "控制音訊播放",

	# UI工具
	"tool_ui_theme_desc": "建立和修改UI主題",
	"tool_ui_control_desc": "配置控制項節點",

	# 訊號工具
	"tool_signal_signal_desc": "全域管理訊號連接",

	# 群組工具
	"tool_group_group_desc": "全域查詢和管理節點群組",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
