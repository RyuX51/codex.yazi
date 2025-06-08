# codex.yazi

A Yazi plugin to launch the Codex CLI in three modes: **suggest**, **auto-edit**, and **full-auto**.

## Installation

### Using `ya pkg add`

```bash
ya pkg add RyuX51/codex
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
[[mgr.prepend_keymap]]
on   = [ "x", "s" ]
run  = "plugin codex suggest"
desc = "Open Codex CLI (suggest mode)"

[[mgr.prepend_keymap]]
on   = [ "x", "e" ]
run  = "plugin codex auto-edit"
desc = "Open Codex CLI (auto-edit mode)"

[[mgr.prepend_keymap]]
on   = [ "x", "f" ]
run  = "plugin codex full-auto"
desc = "Open Codex CLI (full-auto mode)"
```

You can also invoke the plugin manually from the Yazi command prompt:

```text
:plugin codex suggest
:plugin codex auto-edit
:plugin codex full-auto
```

Ensure that the `codex` executable is installed and on your `PATH`.

## Configuration

The plugin ships with sensible defaults:

- `model = "codex-mini-latest"`  
- `provider = "openai"`  
- `images = {}`  
- `view = nil`  
- `history = false`  
- `login = false`  
- `free = false`  
- `quiet = false`  
- `openConfig = false`  
- `writableRoots = {}`  
- `noProjectDoc = false`  
- `projectDocs = {}`  
- `fullStdout = false`  
- `notify = false`  
- `disableResponseStorage = false`  
- `flexMode = false`  
- `reasoning = "high"`  
- `dangerouslyAutoApproveEverything = false`  
- `fullContext = false`  

You can override any of these in your `init.lua`. For example:

```lua
require("codex").setup {
  model                            = "codex-mini-latest",
  provider                         = "openai",
  images                           = {},
  view                             = nil,
  history                          = false,
  login                            = false,
  free                             = false,
  quiet                            = false,
  openConfig                       = false,
  writableRoots                    = {},
  noProjectDoc                     = false,
  projectDocs                      = {},
  fullStdout                       = false,
  notify                           = false,
  disableResponseStorage           = false,
  flexMode                         = false,
  reasoning                        = "high", -- <low|medium|high>
  dangerouslyAutoApproveEverything = false,
  fullContext                      = false
}
```

Any fields you omit will fall back to the defaults listed above. When you press your keybinding, the plugin:

1. Builds a `codex` command line from your settings,  
2. Appends `--approval-mode` to match the key you pressed,  
3. Hides the Yazi UI,  
4. Spawns the interactive Codex CLI,  
5. Restores Yazi when you exit Codex.  

Enjoy full control of your Codex sessions directly from Lua!