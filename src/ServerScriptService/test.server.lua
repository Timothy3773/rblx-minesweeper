local test = require(script.Parent.CellManager)

print(test:generateBoard())

test:renderNilCells()

local cell = test:getCell(Vector3.new(7, 2, 72))

print(test:getAdjacentCells(cell.position))