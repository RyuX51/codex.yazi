# codex.yazi

A Yazi plugin to launch the Codex CLI in three modes: suggest, auto-edit, and full-auto.

## Installation

### Using `ya pack`

```bash
ya pack -a RyuX51/codex
```

### Manual

**Linux/macOS**

```bash
git clone https://github.com/RyuX51/codex.yazi.git \
  ~/.config/yazi/plugins/codex.yazi
```

**Windows**

```powershell
git clone https://github.com/RyuX51/codex.yazi.git \
  %AppData%\yazi\config\plugins\codex.yazi
```

## Usage

Bind one of the following keymaps in your `keymap.toml` to launch Codex directly:

```toml
[[manager.prepend_keymap]]
on   = [ "x", "s" ]
run  = "plugin codex suggest"
desc = "Open Codex CLI (suggest mode)"

[[manager.prepend_keymap]]
on   = [ "x", "e" ]
run  = "plugin codex auto-edit"
desc = "Open Codex CLI (auto-edit mode)"

[[manager.prepend_keymap]]
on   = [ "x", "f" ]
run  = "plugin codex full-auto"
desc = "Open Codex CLI (full-auto mode)"
```

You can also invoke the plugin manually:

```text
:plugin codex suggest
:plugin codex auto-edit
:plugin codex full-auto
```

Ensure that the `codex` executable is installed and on your `PATH`.

## Behavior

When launched, the plugin hides the Yazi UI and directly spawns the Codex CLI (with the selected approval mode).
The plugin blocks the UI until Codex exits, then restores the Yazi interface.