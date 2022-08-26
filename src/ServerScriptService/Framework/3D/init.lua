local Framework = {
    Cells = {},
    Positions = {},
    defaultSettings = {
        rows = 5,
        columns = 5,
        startPosition = Vector3.new(-10, 2, 22),
        cellSize = Vector3.new(3,3,3),
        rowDirection = "Right",
        columnDirection = "Bottom",
        mineDensity = 15
    }
}

local function createColumns(options)
    local sp = options.startPosition
    for c=1,options.columns,1 do
        local columnPosition = {y = c, x = 0}
        local Position
        if options.columnDirection == "Top" then
            Position = Vector3.new(sp.X, sp.Y + options.cellSize.Y * c, sp.Z)
        elseif options.columnDirection == "Bottom" then
            Position = Vector3.new(sp.X, sp.Y - options.cellSize.Y * c, sp.Z)
        end
        print(Position)
    end
end

function Framework:render(options: {rows: number,columns: number,startPosition: Vector3,cellSize: Vector3,rowDirection: Enum.NormalId,columnDirection: Enum.NormalId,mineDensity: number})
    local options = options or Framework.defaultSettings
    print(options)
    createColumns(options)
end

return Framework