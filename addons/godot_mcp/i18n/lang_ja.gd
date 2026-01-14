@tool
extends RefCounted

## 日本語翻訳

const TRANSLATIONS: Dictionary = {
	# Tab names
	"tab_server": "サーバー",
	"tab_tools": "ツール",
	"tab_config": "設定",

	# Header
	"title": "Godot MCP Server",
	"status_running": "実行中",
	"status_stopped": "停止中",

	# Server tab
	"server_status": "サーバー状態",
	"endpoint": "エンドポイント:",
	"connections": "接続数:",
	"settings": "設定",
	"port": "ポート:",
	"auto_start": "自動起動",
	"debug_log": "デバッグログ",
	"btn_start": "開始",
	"btn_stop": "停止",

	# About section
	"about": "情報",
	"author": "作者:",
	"wechat": "WeChat:",

	# Tools tab
	"tools_enabled": "ツール: %d/%d 有効",
	"btn_expand_all": "すべて展開",
	"btn_collapse_all": "すべて折りたたむ",
	"btn_select_all": "すべて選択",
	"btn_deselect_all": "すべて解除",

	# Tool categories - Core
	"cat_scene": "シーン",
	"cat_node": "ノード",
	"cat_script": "スクリプト",
	"cat_resource": "リソース",
	"cat_filesystem": "ファイルシステム",
	"cat_project": "プロジェクト",
	"cat_editor": "エディター",
	"cat_debug": "デバッグ",
	"cat_animation": "アニメーション",

	# Tool categories - Visual
	"cat_material": "マテリアル",
	"cat_shader": "シェーダー",
	"cat_lighting": "ライティング",
	"cat_particle": "パーティクル",

	# Tool categories - 2D
	"cat_tilemap": "タイルマップ",
	"cat_geometry": "ジオメトリ",

	# Tool categories - Gameplay
	"cat_physics": "物理",
	"cat_navigation": "ナビゲーション",
	"cat_audio": "オーディオ",

	# Tool categories - Utilities
	"cat_ui": "UI",
	"cat_signal": "シグナル",
	"cat_group": "グループ",

	# Config tab - IDE section
	"ide_config": "IDE ワンクリック設定",
	"ide_config_desc": "クリックで設定ファイルを自動書き込み、クライアント再起動で有効",
	"btn_one_click": "ワンクリック設定",
	"btn_copy": "コピー",

	# Config tab - CLI section
	"cli_config": "CLI コマンドライン設定",
	"cli_config_desc": "コマンドをコピーしてターミナルで実行",
	"config_scope": "設定範囲:",
	"scope_user": "ユーザー (グローバル)",
	"scope_project": "プロジェクト (現在のみ)",
	"btn_copy_cmd": "コマンドをコピー",

	# Messages
	"msg_config_success": "%s 設定成功!",
	"msg_config_failed": "設定失敗",
	"msg_copied": "%s をクリップボードにコピーしました",
	"msg_parse_error": "設定の解析に失敗",
	"msg_dir_error": "ディレクトリを作成できません: ",
	"msg_write_error": "設定ファイルを書き込めません",

	# Language
	"language": "言語:",

	# ==================== ツール説明 ====================
	# シーンツール
	"tool_scene_management_desc": "シーンの開く・保存・作成・管理",
	"tool_scene_hierarchy_desc": "シーンツリー構造とノード選択を取得",
	"tool_scene_run_desc": "エディターでシーンを実行・テスト",

	# ノードツール
	"tool_node_query_desc": "名前・タイプ・パターンでノードを検索・検査",
	"tool_node_lifecycle_desc": "ノードの作成・削除・複製・インスタンス化",
	"tool_node_transform_desc": "位置・回転・スケールを変更",
	"tool_node_property_desc": "任意のノードプロパティを取得・設定",
	"tool_node_hierarchy_desc": "親子関係と順序を管理",
	"tool_node_signal_desc": "シグナルの接続・切断・発信",
	"tool_node_group_desc": "ノードグループの追加・削除・検索",
	"tool_node_process_desc": "ノード処理モードを制御",
	"tool_node_metadata_desc": "ノードメタデータを取得・設定",
	"tool_node_call_desc": "ノードのメソッドを動的に呼び出し",
	"tool_node_visibility_desc": "ノードの可視性とレイヤーを制御",
	"tool_node_physics_desc": "物理プロパティを設定",

	# リソースツール
	"tool_resource_query_desc": "リソースを検索・検査",
	"tool_resource_manage_desc": "リソースの読み込み・保存・複製",
	"tool_resource_texture_desc": "テクスチャリソースを管理",

	# プロジェクトツール
	"tool_project_info_desc": "プロジェクト情報とパスを取得",
	"tool_project_settings_desc": "プロジェクト設定を読み取り・変更",
	"tool_project_input_desc": "入力アクションマッピングを管理",
	"tool_project_autoload_desc": "自動読み込みシングルトンを管理",

	# スクリプトツール
	"tool_script_manage_desc": "スクリプトの作成・読み取り・変更",
	"tool_script_attach_desc": "ノードにスクリプトをアタッチ・デタッチ",
	"tool_script_edit_desc": "関数・変数・シグナルを追加",
	"tool_script_open_desc": "エディターでスクリプトを開く",

	# エディターツール
	"tool_editor_status_desc": "エディター状態とシーン情報を取得",
	"tool_editor_settings_desc": "エディター設定を読み取り・変更",
	"tool_editor_undo_redo_desc": "元に戻す/やり直し操作を管理",
	"tool_editor_notification_desc": "エディター通知とダイアログを表示",
	"tool_editor_inspector_desc": "インスペクターパネルを制御",
	"tool_editor_filesystem_desc": "ファイルシステムドックと連携",
	"tool_editor_plugin_desc": "エディタープラグインを検索・管理",

	# デバッグツール
	"tool_debug_log_desc": "デバッグメッセージとエラーを出力",
	"tool_debug_performance_desc": "パフォーマンス指標を監視",
	"tool_debug_profiler_desc": "コード実行をプロファイリング",
	"tool_debug_class_db_desc": "Godotクラスデータベースを検索",

	# ファイルシステムツール
	"tool_filesystem_directory_desc": "ディレクトリの作成・削除・一覧",
	"tool_filesystem_file_desc": "ファイルの読み取り・書き込み・管理",
	"tool_filesystem_json_desc": "JSONファイルの読み書き",
	"tool_filesystem_search_desc": "パターンでファイルを検索",

	# アニメーションツール
	"tool_animation_player_desc": "AnimationPlayerノードを制御",
	"tool_animation_animation_desc": "アニメーションの作成・変更",
	"tool_animation_track_desc": "アニメーショントラックの追加・編集",
	"tool_animation_tween_desc": "Tweenの作成・制御",
	"tool_animation_animation_tree_desc": "アニメーションツリーの設定・構成",
	"tool_animation_state_machine_desc": "アニメーションステートマシンを管理",
	"tool_animation_blend_space_desc": "ブレンドスペースを設定",
	"tool_animation_blend_tree_desc": "ブレンドツリーノードを設定",

	# マテリアルツール
	"tool_material_material_desc": "マテリアルの作成・変更",
	"tool_material_mesh_desc": "メッシュリソースを管理",

	# シェーダーツール
	"tool_shader_shader_desc": "シェーダーの作成・編集",
	"tool_shader_shader_material_desc": "シェーダーをマテリアルに適用",

	# ライティングツール
	"tool_lighting_light_desc": "ライトの作成・設定",
	"tool_lighting_environment_desc": "ワールド環境を設定",
	"tool_lighting_sky_desc": "空と大気を設定",

	# パーティクルツール
	"tool_particle_particles_desc": "パーティクルシステムの作成・設定",
	"tool_particle_particle_material_desc": "パーティクルマテリアルを設定",

	# タイルマップツール
	"tool_tilemap_tileset_desc": "タイルセットの作成・編集",
	"tool_tilemap_tilemap_desc": "タイルマップレイヤーとセルを編集",

	# ジオメトリツール
	"tool_geometry_csg_desc": "CSG構成立体ジオメトリを作成",
	"tool_geometry_gridmap_desc": "3Dグリッドマップを編集",
	"tool_geometry_multimesh_desc": "マルチメッシュインスタンスを設定",

	# 物理ツール
	"tool_physics_physics_body_desc": "物理ボディの作成・設定",
	"tool_physics_collision_shape_desc": "コリジョンシェイプの追加・変更",
	"tool_physics_physics_joint_desc": "物理ジョイントと制約を作成",
	"tool_physics_physics_query_desc": "物理クエリとレイキャストを実行",

	# ナビゲーションツール
	"tool_navigation_navigation_desc": "ナビゲーションメッシュとエージェントを設定",

	# オーディオツール
	"tool_audio_bus_desc": "オーディオバスとエフェクトを管理",
	"tool_audio_player_desc": "オーディオ再生を制御",

	# UIツール
	"tool_ui_theme_desc": "UIテーマの作成・変更",
	"tool_ui_control_desc": "コントロールノードを設定",

	# シグナルツール
	"tool_signal_signal_desc": "シグナル接続をグローバルに管理",

	# グループツール
	"tool_group_group_desc": "ノードグループをグローバルに検索・管理",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
