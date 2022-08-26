local Framework = {
    Cells = {},
    Positions = {},
    defaultSettings = {
        rows = 5,
        columns = 5,
        startPosition = Vector3.new(-10, 2, 22),
        cellSize = Vector3.new(2,5,3),
        rowDirection = "Front",
        columnDirection = "Left",
        mineDensity = 15
    }
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CellClickEvent = Instance.new("BindableEvent", ReplicatedStorage)

local function createPositions(options)
    local sp = options.startPosition
    local ocd = options.columnDirection
    local ord = options.rowDirection
    for c=1,options.columns,1 do
        local Position = sp + Vector3.FromNormalId(ocd) * options.cellSize * c
        for r=1,options.rows,1 do
            local RowPosition = Position + Vector3.FromNormalId(ord) * options.cellSize * r
            table.insert(Framework.Positions, {y = c, x = r, pos = RowPosition})
        end
    end
end

local function validatePosition(x: number ,y: number)
    for __, pos in Framework.Positions do
        if pos.x == x and pos.y == y then
            return true
        end
    end
    return false
end

local function createCell(path, options, data)
    local Cell = Instance.new("Part")
    Cell.Anchored = true
    Cell.Size = options.cellSize
    Cell.Position = data.pos
    Cell.Parent = path
    Cell:SetAttribute("x", data.x)
    Cell:SetAttribute("y", data.y)
    Cell:SetAttribute("type", "n/a")
    table.insert(Framework.Cells, Cell)
end


function Framework.Cells:getCells()
    return Framework.Cells
end

function Framework:render(path, options: {rows: number,columns: number,startPosition: Vector3,cellSize: Vector3,rowDirection: Enum.NormalId,columnDirection: Enum.NormalId,mineDensity: number})
    local options = options or Framework.defaultSettings
    if path == nil then return error("Argument path is missing") end
    local CellFolder = Instance.new("Folder")
    CellFolder.Name = "Cells"
    CellFolder.Parent = path
    createPositions(options)
    for __, data in Framework.Positions do
        createCell(CellFolder, options, data)
    end
end

return Framework