local cellManager = {
    settings = {
        rows = 50,
        cellsPerRow = 50,
        mineDensity = 50,
        startPos = Vector3.new(-2, 2, 66),
        cellSize = Vector3.new(1,3,1)
    },
    Cells = {}
}

self = cellManager

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
        table.insert(self.Cells, {x = pos.x, y = pos.y, cell = cellPart, cellType = "n/a"})
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

function cellManager:getAdjacentBombs(tbl)
    local result = 0
    for __,cell in tbl do
        if cell.cellType == "bomb" then
            result += 1
        end
    end
    return result
end

function cellManager:renderMines()
    for m=1,self.settings.mineDensity,1 do
        local randomCell = self:getCell(math.random(0,self.settings.rows),math.random(0,self.settings.cellsPerRow))
        if randomCell ~= nil then
            if randomCell.cellType ~= "bomb" then
                randomCell.cellType = "bomb"
                randomCell.cell.Name = "BombCell"
                randomCell.cell:SetAttribute("type", "bomb")
                randomCell.cell.BrickColor = BrickColor.Red()
            else
                m -= 1
            end
        else
            m -= 1
        end
    end
end

function cellManager:renderNumberCells()
    local bombCells = {}
    for __,cell in self.Cells do
        if cell.cellType == "bomb" then
            table.insert(bombCells, cell)
        end
    end
    task.wait(2)
    for __, bomb in bombCells do
        for adj,adjCells in self:getAdjacentCells(bomb.x, bomb.y) do
            if adjCells.cellType == "n/a" then
                adjCells.cellType = "numberCell"
                adjCells.cell.Name = "NumberCell"
                adjCells.cell:SetAttribute("type", "numberCell")
            end
        end
    end
    for __, test in self.Cells do
        if test.cellType == "numberCell" then
            test.cell:SetAttribute("touching", self:getAdjacentBombs(self:getAdjacentCells(test.x, test.y)))
            local ui = Instance.new("SurfaceGui")
            ui.Adornee = test.cell
            ui.PixelsPerStud = 250
            ui.Face = Enum.NormalId.Top
            local textLabel = Instance.new("TextLabel")
            textLabel.Text = test.cell:GetAttribute("touching")
            textLabel.BackgroundColor3 = Color3.fromRGB(156, 156, 117)
            textLabel.BackgroundTransparency = 0.15
            textLabel.BorderSizePixel = 0
            textLabel.Size = UDim2.new(1,0,1,0)
            textLabel.RichText = true
            textLabel.TextScaled = true
            textLabel.TextWrapped = true
            textLabel.Parent = ui
            ui.Parent = test.cell
        end
    end
end

function cellManager:renderEverythingElse()
    for __,cell in self.Cells do
        if cell.cellType == "n/a" then
            cell.cellType = "empty"
            cell.cell.Name = "EmptyCell"
            cell.cell:SetAttribute("type", "empty")
        end
    end
end

function cellManager:clearBoard()
    table.clear(self.Cells)
    for __, cell: Part in cellFolder:GetChildren() do
        cell:Destroy()
    end
    return "Cells", self.Cells,"Cell Folder", cellFolder:GetChildren()
end

return cellManager