# Tmux Toggle Panel

A tmux plugin that provides a toggle functionality for a sidebar panel. The plugin allows users to show/hide a rightmost pane by converting it to/from a hidden window.


https://github.com/user-attachments/assets/cc8d05e7-d328-4941-8772-55eb389a488e


## Features

- **Panel Toggle**: Shows/hides rightmost pane by moving it to/from a hidden window named "hidden_panel"
- **Auto-creation**: If only one pane exists, creates a new empty shell pane as sidebar
- **Width Persistence**: Saves manually resized panel width using tmux option `@toggle-panel-width`
- **Smart Width Detection**: Only persists width if user manually resized (differs from default 25% by >2%)
- **Intelligent Focus**: Maintains proper focus handling when toggling panels

## Installation

### Using TPM (Tmux Plugin Manager)

1. Add plugin to your `~/.tmux.conf`:
```bash
set -g @plugin 'madebyae/tmux-toggle-panel'
```

2. Press `prefix + I` to install the plugin

### Manual Installation

1. Clone this repository to your tmux plugins directory:
```bash
git clone https://github.com/madebyae/tmux-toggle-panel ~/.tmux/plugins/tmux-toggle-panel
```

2. Add to your `~/.tmux.conf`:
```bash
run-shell ~/.tmux/plugins/tmux-toggle-panel/plugin.tmux
```

3. Reload tmux configuration:
```bash
tmux source-file ~/.tmux.conf
```

## Use Cases

### AI-Powered Development Workflows

This plugin is perfect for modern AI-assisted development environments:

- **Claude Code**: Keep your main editor in the left pane, toggle the right panel for Claude Code terminal sessions
- **OpenAI Codex**: Hide/show the Codex interface when you need AI assistance without disrupting your workflow
- **Gemini CLI**: Toggle between your code editor and Gemini CLI for quick AI consultations
- **GitHub Copilot Chat**: Dedicate the sidebar to Copilot Chat while keeping your main development environment clean

### Terminal-Based Development

- **File Explorer**: Use the sidebar for `ranger`, `lf`, or `nnn` file managers
- **Documentation**: Keep `man pages`, `tldr`, or documentation viewers in the toggleable panel
- **System Monitoring**: Monitor system resources with `htop`, `btop`, or similar tools
- **Git Operations**: Dedicate the sidebar to git status, logs, and interactive operations
- **Testing**: Run test suites or continuous integration feedback in the sidebar

### Productivity Workflows

- **Note Taking**: Keep `vim` or `nano` open for quick notes and todos
- **Task Management**: Use CLI task managers like `taskwarrior` or `todo.txt`
- **Communication**: Toggle Slack, Discord, or IRC clients when needed
- **Research**: Keep `curl`, `httpie`, or API testing tools accessible

## Usage

### Basic Usage

- **Default Key Binding**: Press `prefix + \` to toggle the sidebar panel
- **First Toggle**: If only one pane exists, creates a new sidebar pane on the right
- **Subsequent Toggles**: Shows/hides the rightmost pane

### Configuration

Add these options to your `~/.tmux.conf`:

```bash
# Custom key binding (default: \)
set -g @toggle-panel-key '|'

# The plugin will automatically manage panel width
# No need to set @toggle-panel-width manually
```

### Width Persistence

The plugin automatically saves your panel width when you manually resize it:

1. Create or show the sidebar panel
2. Manually resize it using `prefix + arrow keys` or mouse
3. The new width is automatically saved if it differs from default (25%) by more than 2%
4. Next time you toggle the panel, it will restore to your preferred width

## How It Works

### Toggle Logic

1. **Panel Hidden**: If hidden window exists, join it back as a pane on the right
2. **Single Pane**: Creates new empty shell pane as sidebar, then hides it
3. **Multiple Panes**: Hides the rightmost pane by breaking it into a hidden window

### File Structure

- **plugin.tmux**: Main plugin entry point that sets up key bindings
- **toggle-panel.sh**: Core toggle logic with auto-creation and width persistence
- **plugin-entry.sh**: Alternative entry point that sources main plugin

## Testing

Test the plugin functionality:

1. **Single Pane Test**: Start with one pane, press toggle key
   - Should create new sidebar pane, then hide it
   - Toggle again should show the sidebar

2. **Multiple Panes Test**: Have multiple panes open
   - Toggle should hide/show the rightmost pane
   - Focus should remain on a visible pane

3. **Width Persistence Test**: 
   - Show sidebar, manually resize it
   - Hide and show again - width should be preserved
   - Only saves if width differs from 25% by more than 2%

## Configuration Options

| Option | Default | Description |
|--------|---------|-------------|
| `@toggle-panel-key` | `\` | Key binding for toggle (after prefix) |
| `@toggle-panel-width` | `25` | Panel width percentage (auto-managed) |

## Troubleshooting

### Panel Not Toggling
- Ensure plugin is properly installed and loaded
- Check if key binding conflicts with other plugins
- Verify tmux version compatibility

### Width Not Persisting
- Width only saves if manually resized by more than 2% from default
- Check if `@toggle-panel-width` option is being set correctly
- Ensure tmux has write permissions for options

### Focus Issues
- Plugin handles focus automatically when hiding panels
- If focus seems lost, try pressing `prefix + arrow keys` to navigate

## Development

### Code Structure

- Uses bash with `set -euo pipefail` for safety
- Follows tmux plugin conventions
- Handles edge cases (no panes, single pane, invalid width)
- Width calculation uses integer arithmetic for tmux compatibility

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly with different pane configurations
5. Submit a pull request

## License

MIT License - see LICENSE file for details
