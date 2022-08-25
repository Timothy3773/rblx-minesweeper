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

local board :Folder = game.Workspace:FindFirstChild("Board")
local cellFolder :Folder = board:FindFirstChild("Cells")



local positions = {}

function cellManager.generateBoard()
    local settings = cellManager.settings
    for r=1,settings.rows,1 do 
        local RowPosition = Vector3.new(settings.startPos.X + settings.cellSize.X * r, settings.startPos.Y, settings.startPos.Z)
        table.insert(positions, RowPosition)
        for c=1,settings.cellsPerRow,1 do
            local CellPosition = Vector3.new(RowPosition.X, RowPosition.Y, RowPosition.Z + settings.cellSize.Z * c)
            table.insert(positions, CellPosition)
        end
    end
    return positions
end

function cellManager:renderNilCells()
	for __, pos: Vector3 in positions do
        local Cell = Instance.new("Part")
        Cell.Anchored = true
        Cell.Size = cellManager.settings.cellSize
        Cell.Position = pos
		Cell.Parent = cellFolder
		table.insert(cellManager.Cells, {position = Cell.Position, part = Cell, cellType = "notAssigned"})
    end
end

function cellManager:getCell(pos: Vector3)
	for __,cell in cellManager.Cells do
		if cell.position == pos then
			return cell
		else
			return nil
		end
	end
end

function cellManager:getAdjacentCells(pos: Vector3)
    local cell = cellManager:getCell(pos)
    local calculations = {
        Vector3.new(cell.position.X, cell.position.Y, cell.position.Z)
    }
    for __,calc in calculations do
        print(calc)
    end
end

return cellManager