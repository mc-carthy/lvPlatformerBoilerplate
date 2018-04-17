local player = {}

local debug = false

local moveSpeed = 300
local jumpSpeed = -1
local gravity = 5
local jumpPressed = false

local _horizontalCollision = function(self, dt, input)
    for i, col in ipairs(self.cornerOffsets) do
        if self.entityManager:getGrid():isSolid(self.x + col.x + input.x, self.y + col.y) then
            self.vx = 0
            -- self.x = Math.roundToNearest(self.x, GRID_SIZE) - col.x - Math.sign(self.moveX) * collisionBuffer
            return true
        end
    end
    return false
end

local _verticalCollision = function(self, dt, input)
    for i, col in ipairs(self.cornerOffsets) do
        if self.entityManager:getGrid():isSolid(self.x + col.x, self.y + col.y + self.vy + input.y) then
            self.vy = 0
            self.isGrounded = true
            self.numJumps = 2
            -- self.y = Math.roundToNearest(self.y, GRID_SIZE) - col.y - Math.sign(self.moveY) * collisionBuffer
            return true
        else
            self.vy = self.vy + input.y
        end
    end
    return false
end

local function _checkCollision(self, dt)
    -- if self.entityManager:getGrid():isSolid(self.x + self.w, self.y + self.h + self.vy) or self.entityManager:getGrid():isSolid(self.x, self.y + self.h + self.vy) then
    --     self.vy = 0
    --     self.isGrounded = true
    -- end
    _horizontalCollision(self, dt)
    _verticalCollision(self, dt)
end

local function _move(self, dt, input)
    if not _horizontalCollision(self, dt, input) then
        self.x = self.x + input.x
    end
    if not _verticalCollision(self, dt, input) then
        self.y = self.y + self.vy
    end
end

local function _applyGravity(self, dt)
    if not self.isGrounded then
        self.vy = self.vy + gravity * dt
    end
end

local function _getInput(self, dt)
    local up = love.keyboard.isDown('up') or love.keyboard.isDown('w')
    local down = love.keyboard.isDown('down') or love.keyboard.isDown('s')
    local left = love.keyboard.isDown('left') or love.keyboard.isDown('a')
    local right = love.keyboard.isDown('right') or love.keyboard.isDown('d')
    local jump = love.keyboard.isDown('space')
    
    local motion = {
        x = 0,
        y = 0
    }

    if left then
        motion.x = motion.x - moveSpeed * dt
    end
    if right then
        motion.x = motion.x + moveSpeed * dt
    end
    -- if up then
    --     motion.y = motion.y - moveSpeed * dt
    -- end
    -- if down then
    --     motion.y = motion.y + moveSpeed * dt
    -- end
    if jump and (self.isGrounded or self.numJumps > 0) and not jumpPressed then
        jumpPressed = true
        self.numJumps = self.numJumps - 1
        motion.y = jumpSpeed
        self.isGrounded = false
    end
    if not jump then
        jumpPressed = false
    end
    motion.y = motion.y + gravity * dt
    return motion
end

local function update(self, dt)
    local motion = _getInput(self, dt)
    _move(self, dt, motion)
end

local function draw(self)
    love.graphics.setColor(191, 0, 0, 255)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setLineWidth(2)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.setLineWidth(1)
    if debug then
        for _, col in ipairs(self.cornerOffsets) do
            love.graphics.setColor(191, 0, 191, 255)
            love.graphics.circle("fill", self.x + col.x, self.y + col.y, 5)
        end
    end
    love.graphics.setColor(255, 255, 255, 255)
end

function player.create(entityManager, x, y)
    local inst = {}

    inst.entityManager = entityManager
    inst.tag = 'player'
    inst.x = x or 0
    inst.y = y or 0
    inst.w = 20
    inst.h = 20
    inst.vx = 0
    inst.vy = 0
    inst.numJumps = 2
    inst.cornerOffsets = {
        { x = 0, y = 0 },
        { x = 0, y = inst.h },
        { x = inst.w, y = 0  },
        { x = inst.w, y = inst.h  }
    }

    inst.update = update
    inst.draw = draw

    return inst
end

return player