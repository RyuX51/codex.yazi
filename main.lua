return {
    entry = function(_, job)
        local mode = job.args[1]
        local approval
        if mode == "s" or mode == "suggest" then
            approval = "suggest"
        elseif mode == "e" or mode == "auto-edit" then
            approval = "auto-edit"
        elseif mode == "f" or mode == "full-auto" then
            approval = "full-auto"
        end

        local permit = ya.hide()
        local cmd = Command("codex")
        if approval then
            cmd = cmd:arg("--approval-mode"):arg(approval)
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