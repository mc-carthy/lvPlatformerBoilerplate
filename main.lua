local EntityManager = require('src.entities.entityManager')
local Grid = require('src.map.grid')
local Player = require('src.entities.player')

function love.load()
    entityManager = EntityManager.create()
    entityManager:addEntity(Grid.create(entityManager))
    entityManager:addEntity(Player.create(entityManager, 100, love.graphics.getHeight() - 100))
end

function love.update(dt)
    entityManager:update(dt)
end

function love.draw()
    entityManager:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end