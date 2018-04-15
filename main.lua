local Player = require('src.entities.player')

function love.load()
    player = Player.create(100, love.graphics.getHeight() - 100)
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(63, 63, 63, 255)
    player:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end