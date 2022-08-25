local test = require(script.Parent.CellManager)

test:renderPositions()

test:renderNilCells()

local cell = test:getCell(2,2)

print("Cell", cell, "Adjacent Cells", test:getAdjacentCells(cell.x, cell.y))