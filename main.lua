--- @since 25.5.31

local M = {}

-- Default configuration for codex CLI
local defaults = {
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

-- Copy defaults into a working cfg
local cfg = {}
for k, v in pairs(defaults) do
  if type(v) == "table" then
    cfg[k] = { table.unpack(v) }
  else
    cfg[k] = v
  end
end

--- Setup function: call this from your init.lua with any subset of the above keys.
---
--- Example:
--- require("codex").setup {
---   model           = "o3",
---   provider        = "openai",
---   flexMode        = true,
---   reasoning       = "medium",
---   images          = { "diagram.png" },
---   writableRoots   = { "." },
---   noProjectDoc    = true,
---   projectDocs     = { "GUIDE.md" },
---   notify          = true,
--- }
function M.setup(user_cfg)
  if type(user_cfg) ~= "table" then
    return
  end
  for k, v in pairs(user_cfg) do
    if cfg[k] ~= nil then
      cfg[k] = v
    end
  end
end

-- Build the actual `codex` Command by folding in cfg and then the approval-mode
local function build_cmd(mode)
  local cmd = Command("codex")

  -- flag by flag
  if cfg.model                         then cmd:arg("--model"):arg(cfg.model) end
  if cfg.provider                      then cmd:arg("--provider"):arg(cfg.provider) end
  for _, img in ipairs(cfg.images)     do cmd:arg("--image"):arg(img) end
  if cfg.view                          then cmd:arg("--view"):arg(cfg.view) end
  if cfg.history                       then cmd:arg("--history") end
  if cfg.login                         then cmd:arg("--login") end
  if cfg.free                          then cmd:arg("--free") end
  if cfg.quiet                         then cmd:arg("--quiet") end
  if cfg.openConfig                    then cmd:arg("--config") end
  for _, root in ipairs(cfg.writableRoots) do
    cmd:arg("--writable-root"):arg(root)
  end
  if cfg.noProjectDoc                  then cmd:arg("--no-project-doc") end
  for _, doc in ipairs(cfg.projectDocs) do
    cmd:arg("--project-doc"):arg(doc)
  end
  if cfg.fullStdout                    then cmd:arg("--full-stdout") end
  if cfg.notify                        then cmd:arg("--notify") end
  if cfg.disableResponseStorage        then cmd:arg("--disable-response-storage") end
  if cfg.flexMode                      then cmd:arg("--flex-mode") end
  if cfg.reasoning                     then cmd:arg("--reasoning"):arg(cfg.reasoning) end
  if cfg.dangerouslyAutoApproveEverything then
    cmd:arg("--dangerously-auto-approve-everything")
  end
  if cfg.fullContext                   then cmd:arg("--full-context") end

  -- finally the mode we invoked: "suggest" | "auto-edit" | "full-auto"
  if mode then
    cmd:arg("--approval-mode"):arg(mode)
  end

  -- keep it interactive
  return cmd
    :stdin (Command.INHERIT)
    :stdout(Command.INHERIT)
    :stderr(Command.INHERIT)
end

--- entry point: job.args[1] must be "suggest", "auto-edit" or "full-auto"
function M.entry(_, job)
  local mode = job.args[1]
  assert(
    mode == "suggest" or mode == "auto-edit" or mode == "full-auto",
    "codex.yazi: invalid mode: " .. tostring(mode)
  )
  local permit = ya.hide()    -- hide the Yazi UI

  local child, err = build_cmd(mode):spawn()
  if not child then
    ya.notify {
      title   = "codex.yazi",
      content = "Install codex via 'npm install -g @openai/codex'",
      level   = "error",
      timeout = 5,
    }
    permit:drop()
    return
  end

  child:wait()  -- block until exit
  permit:drop()
end

return M