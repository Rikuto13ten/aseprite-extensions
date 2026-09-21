Timer {
    interval = 0.6,
    ontick = function ()
        local mousePos = app.editor.spritePos
        print(mousePos)
    end
}
