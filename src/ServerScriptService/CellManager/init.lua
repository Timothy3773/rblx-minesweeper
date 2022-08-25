local cellManager = {
    settings = {
        rows = 5,
        cellsPerRow = 5,
        mineDensity = 10,
        startPos = Vector3.new(-2, 2, 66),
        cellSize = Vector3.new(3,3,3)
    },
    Cells = {}
}

local self = cellManager

local board: Folder = game.Workspace:FindFirstChild("Board")
local cellFolder: Folder = board:FindFirstChild("Cells")

local positions = {}

function cellManager:renderPositions()
    for r=1,self.settings.rows,1 do
        for c=1,self.settings.cellsPerRow,1 do
            table.insert(positions, {
                x = r - 1,
                y = c - 1,
                vector = Vector3.new(self.settings.startPos.X + self.settings.cellSize.X * r,
                self.settings.startPos.Y,
                self.settings.startPos.Z + self.settings.cellSize.Z * c)
        })
        end
    end

    return positions
end

function cellManager:renderNilCells()
    for __,pos in positions do
        local cellPart = Instance.new("Part")
        cellPart.Anchored = true
        cellPart.Size = self.settings.cellSize
        cellPart.Position = pos.vector
        cellPart:SetAttribute("x", pos.x)
        cellPart:SetAttribute("y", pos.y)
        cellPart.Parent = cellFolder
        table.insert(self.Cells, {x = pos.x, y = pos.y, cell = cellPart})
    end
end

function cellManager:getCell(x,y)
    for __,cell in self.Cells do
        if cell.x == x and cell.y == y then
            return cell
        end
    end
    return nil
end

function cellManager:getAdjacentCells(x,y)
    local result = {}
    local cell = self:getCell(x,y)
    local cx = cell.x
    local cy = cell.y
    local calculations = {
        {x = cx + 1, y = cy}, 
        {x = cx - 1, y = cy},
        {x = cx + 1, y = cy + 1},
        {x = cx - 1, y = cy - 1},
        {x = cx + 1, y = cy - 1},
        {x = cx - 1, y = cy + 1},
        {x = cx, y = cy + 1},
        {x = cx, y = cy - 1}
    }
    for __, calc in calculations do
        if self:getCell(calc.x, calc.y) ~= nil then
            table.insert(result, self:getCell(calc.x, calc.y))
        end
    end
    return result
end

return cellManager