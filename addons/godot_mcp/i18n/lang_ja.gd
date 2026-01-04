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
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
