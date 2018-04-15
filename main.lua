local Grid = require('src.map.grid')
local Player = require('src.entities.player')

function love.load()
    grid = Grid.create()
    player = Player.create(100, love.graphics.getHeight() - 100)
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(63, 63, 63, 255)
    grid:draw()
    player:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end