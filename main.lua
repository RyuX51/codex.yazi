--- @since 25.5.31

return {
    entry = function(_, job)
        local mode = job.args[1]
        assert(mode == "suggest" or mode == "auto-edit" or mode == "full-auto", "Invalid action")

        local permit = ya.hide()
        local cmd = Command("codex")
        if mode then
            cmd = cmd:arg("--approval-mode"):arg(mode)
        end
        cmd = cmd:stdin(Command.INHERIT)
                 :stdout(Command.INHERIT)
                 :stderr(Command.INHERIT)
        local child, err = cmd:spawn()
        if not child then
            ya.notify({
                title = "codex.yazi",
                content = "Failed to spawn codex: " .. tostring(err),
                level = "error",
                timeout = 5,
            })
            permit:drop()
            return
        end
        child:wait()
        permit:drop()
    end,
}