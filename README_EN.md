# Godot MCP Server

English | [中文](./README.md)

A Model Context Protocol (MCP) server plugin for Godot Engine, enabling AI assistants to interact directly with the Godot Editor for AI-driven game development.

## Features

### Core Features
- **Scene Management** - Create, open, save scenes, view scene tree structure
- **Node Operations** - Add, delete, move nodes, modify node properties
- **Script Editing** - Create, read, modify GDScript scripts
- **Resource Management** - Load, create, modify game resources
- **File System** - Browse project files, read and write file content
- **Editor Control** - Control editor interface, manage selections, undo/redo
- **Debug Tools** - View logs, get runtime information
- **Animation Tools** - Create and edit animations, state machine management

### Visual Effects
- **Material Tools** - Create and configure materials
- **Shader Tools** - Manage shader parameters
- **Lighting Tools** - Configure scene lighting
- **Particle Tools** - Create particle effects

### 2D Development
- **TileMap Tools** - TileMap editing and configuration
- **Geometry Tools** - 2D geometry creation

### Gameplay
- **Physics Tools** - Physics body and collision configuration
- **Navigation Tools** - Navigation mesh and pathfinding
- **Audio Tools** - Audio playback and configuration

### Utilities
- **UI Tools** - User interface components
- **Signal Tools** - Signal connection management
- **Group Tools** - Node group management

### Multi-Language Support
The plugin interface supports 9 languages with automatic system language detection:
- English
- 简体中文 (Simplified Chinese)
- 繁體中文 (Traditional Chinese)
- 日本語 (Japanese)
- Русский (Russian)
- Français (French)
- Português (Portuguese)
- Español (Spanish)
- Deutsch (German)

## Supported AI Clients

### IDE Editors (One-Click Configuration)
- **Trae CN** - AI Editor (Chinese Version)
- **Cursor** - AI Code Editor
- **Windsurf** - Codeium's AI Editor

### CLI Tools (Command Copy)
- **Claude CLI** - Anthropic Claude Command Line Tool
- **Codex CLI** - OpenAI Codex Command Line Tool
- **Gemini CLI** - Google Gemini Command Line Tool

## Requirements

- Godot Engine 4.x
- Supported OS: Windows, macOS, Linux

## Installation


1. Download or clone this repository:
   ```bash
   git clone https://github.com/DaxianLee/godot-mcp.git
   ```

2. Copy the `addons/godot_mcp` folder to your Godot project's `addons` directory:
   ```
   your_project/
   ├── addons/
   │   └── godot_mcp/
   │       ├── plugin.cfg
   │       ├── plugin.gd
   │       ├── mcp_server.gd
   │       ├── i18n/
   │       └── tools/
   └── ...
   ```

3. In Godot Editor, go to `Project -> Project Settings -> Plugins`

4. Find **Godot MCP Server** and enable it


## Usage Guide

### 1. Start MCP Server

After enabling the plugin, you'll see the **GodotMCP** panel on the right side of the editor:

- **Server** - Shows server running status, endpoint address, author info
- **Tools** - Manage available MCP tools (displayed by category)
- **Config** - IDE one-click configuration and CLI command copy

Default configuration:
- Port: `3000`
- Address: `http://127.0.0.1:3000/mcp`
- Auto-start: Enabled

### 2. Configure AI Client

#### IDE Editors - One-Click Configuration

Switch to the "Config" tab in the GodotMCP panel to see supported IDE clients.

##### Trae CN

1. Click the "One-Click Config" button under Trae CN
2. Restart Trae CN

Config file location:
- **macOS**: `~/Library/Application Support/Trae CN/User/mcp.json`
- **Windows**: `%APPDATA%\Trae CN\User\mcp.json`
- **Linux**: `~/.config/Trae CN/User/mcp.json`

##### Cursor

1. Click the "One-Click Config" button under Cursor
2. Restart Cursor

Config file location: `~/.cursor/mcp.json`

##### Windsurf

1. Click the "One-Click Config" button under Windsurf
2. Restart Windsurf

Config file location: `~/.codeium/windsurf/mcp_config.json`

#### CLI Tools - Copy Command

CLI tools require running commands in the terminal to configure. In the "Config" tab:

1. Use the "Configuration Scope" dropdown to select scope:
   - **User-level** - Global effect, available for all projects
   - **Project-level** - Current project only

2. Copy the corresponding command and run it in the terminal

##### Claude CLI (Claude Code)

```bash
claude mcp add --scope <user|project> --transport http godot-mcp http://127.0.0.1:3000/mcp
```

##### Codex CLI

```bash
codex mcp add --scope <user|project> --transport http godot-mcp http://127.0.0.1:3000/mcp
```

##### Gemini CLI

```bash
gemini mcp add --scope <user|project> --transport http godot-mcp http://127.0.0.1:3000/mcp
```

### 3. Getting Started

After configuration, you can directly operate Godot projects in the AI client:

```
User: Create a new scene and add a Sprite2D node

AI: Sure, let me create the scene for you...
    [Calling scene_create to create scene]
    [Calling node_add to add Sprite2D node]
    Done! Created a new scene with a Sprite2D node.
```

## Tool List

### Core Tools

#### Scene Tools
| Tool Name | Description |
|-----------|-------------|
| `scene_create` | Create a new scene |
| `scene_open` | Open a specified scene |
| `scene_save` | Save current scene |
| `scene_get_tree` | Get scene tree structure |
| `scene_get_current` | Get current scene info |

#### Node Tools
| Tool Name | Description |
|-----------|-------------|
| `node_add` | Add a new node |
| `node_delete` | Delete a node |
| `node_get` | Get node information |
| `node_set_property` | Set node property |
| `node_get_property` | Get node property |
| `node_move` | Move node position |
| `node_rename` | Rename node |
| `node_duplicate` | Duplicate node |
| `node_find` | Find nodes |

#### Script Tools
| Tool Name | Description |
|-----------|-------------|
| `script_create` | Create a new script |
| `script_read` | Read script content |
| `script_write` | Write script content |
| `script_attach` | Attach script to node |

#### Resource Tools
| Tool Name | Description |
|-----------|-------------|
| `resource_load` | Load a resource |
| `resource_create` | Create a resource |
| `resource_save` | Save a resource |

#### Filesystem Tools
| Tool Name | Description |
|-----------|-------------|
| `filesystem_list` | List directory contents |
| `filesystem_read` | Read a file |
| `filesystem_write` | Write a file |
| `filesystem_delete` | Delete a file |

#### Project Tools
| Tool Name | Description |
|-----------|-------------|
| `project_get_info` | Get project information |
| `project_get_settings` | Get project settings |

#### Editor Tools
| Tool Name | Description |
|-----------|-------------|
| `editor_get_selection` | Get current selection |
| `editor_select_node` | Select a specified node |
| `editor_undo_redo` | Undo/redo operations |

#### Debug Tools
| Tool Name | Description |
|-----------|-------------|
| `debug_get_logs` | Get debug logs |

#### Animation Tools
| Tool Name | Description |
|-----------|-------------|
| `animation` | Create and edit animations |
| `animation_state_machine` | State machine management |

### Visual Tools

#### Material Tools
| Tool Name | Description |
|-----------|-------------|
| `material` | Create and configure materials |

#### Shader Tools
| Tool Name | Description |
|-----------|-------------|
| `shader` | Shader parameter management |

#### Lighting Tools
| Tool Name | Description |
|-----------|-------------|
| `lighting` | Scene lighting configuration |

#### Particle Tools
| Tool Name | Description |
|-----------|-------------|
| `particle` | Particle effect creation |

### 2D Tools

#### TileMap Tools
| Tool Name | Description |
|-----------|-------------|
| `tilemap` | TileMap editing |

#### Geometry Tools
| Tool Name | Description |
|-----------|-------------|
| `geometry` | 2D geometry shapes |

### Gameplay Tools

#### Physics Tools
| Tool Name | Description |
|-----------|-------------|
| `physics` | Physics body and collision configuration |

#### Navigation Tools
| Tool Name | Description |
|-----------|-------------|
| `navigation` | Navigation mesh and pathfinding |

#### Audio Tools
| Tool Name | Description |
|-----------|-------------|
| `audio` | Audio playback and configuration |

### Utility Tools

#### UI Tools
| Tool Name | Description |
|-----------|-------------|
| `ui` | User interface components |

#### Signal Tools
| Tool Name | Description |
|-----------|-------------|
| `signal` | Signal connection management |

#### Group Tools
| Tool Name | Description |
|-----------|-------------|
| `group` | Node group management |

## FAQ

### Q: Server won't start?
A: Check if the port is occupied, try changing the port and restart.

### Q: AI client can't connect?
A:
1. Make sure the MCP server is running (status shows green)
2. Check if the port number in the config file is correct
3. Restart the AI client

### Q: What to do after changing the port?
A: Update the port number in the AI client's config file accordingly, then restart the client.

### Q: How to change the interface language?
A: In the "Server" tab settings area, use the "Language" dropdown to select your preferred language.

## License

This project is licensed under a **Non-Commercial Use License**.

### Allowed:
- Personal learning and research use
- Non-commercial open source projects
- Educational and teaching purposes

### Prohibited:
- Commercial use (including but not limited to selling, integrating into commercial products)
- Unauthorized redistribution

For commercial licensing, please contact the author.

## Author

**LIDAXIAN**

- GitHub: [https://github.com/DaxianLee/godot-mcp](https://github.com/DaxianLee/godot-mcp)
- WeChat: `lidaxian-AI`

## Contributing

Issues and Pull Requests are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Acknowledgments

- [Godot Engine](https://godotengine.org/) - Open source game engine
- [Model Context Protocol](https://modelcontextprotocol.io/) - AI interaction protocol specification

---

If this project helps you, please give it a Star!
