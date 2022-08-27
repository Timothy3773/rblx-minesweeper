local test = require(script.Parent.Framework["3D"])

test:render(game.Workspace, test.defaultSettings)

test.OnCalled:Connect(function(whatisthisfor: nil, ...)
    print(...)
end)
