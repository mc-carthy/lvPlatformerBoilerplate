local level1 = require('src.map.levels.level1')

local grid = {}

local cell_size = 25

local function createLevel(self, level)
    local y = 0
    for row in level.string:gmatch('(.-)\n') do
        y = y + 1
        self.grid[y] = {}
        local x = 0
        for tile in row:gmatch('.') do
            x = x + 1
            if tile == '-' then
                self.grid[y][x] = '-'
            elseif tile == 'x' then
                self.grid[y][x] = 'x'
            end
        end
    end
end

local function isSolid(self, x, y)
    if self.grid[math.floor(y / cell_size) + 1] and self.grid[math.floor(y / cell_size) + 1][math.floor(x / cell_size) + 1] then
        return self.grid[math.floor(y / cell_size) + 1][math.floor(x / cell_size) + 1] == 'x'
    else
        return true
    end
end

local function draw(self)
    for y = 1, #self.grid do
        for x = 1, #self.grid[y] do
            if self.grid[y][x] == 'x' then
                love.graphics.setColor(127, 127, 0, 255)
            elseif self.grid[y][x] == '-' then
                love.graphics.setColor(0, 127, 191, 255)
            end
            love.graphics.rectangle('fill', (x - 1) * cell_size, (y - 1) * cell_size, cell_size, cell_size)
            love.graphics.setColor(0, 0, 0, 255)
            -- love.graphics.rectangle('line', (x - 1) * cell_size, (y - 1) * cell_size, cell_size, cell_size)
            -- love.graphics.print('y:' .. y .. ' x:' .. x , (x - 1) * cell_size, (y - 1) * cell_size, 0, 0.5, 0.5)
        end
    end
    love.graphics.setColor(255, 255, 255, 255)
end

function grid.create(entityManager)
    local inst = {}

    inst.entityManager = entityManager
    inst.tag = 'grid'
    inst.grid = {}

    createLevel(inst, level1)

    inst.isSolid = isSolid

    inst.draw = draw

    return inst
end

return grid