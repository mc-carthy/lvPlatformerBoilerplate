local player = {}

local moveSpeed = 200
local jumpSpeed = -25
local gravity = 100

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
    
    if left then
        self.x = self.x - moveSpeed * dt
    end
    if right then
        self.x = self.x + moveSpeed * dt
    end
    if jump and self.isGrounded then
        self.vy = jumpSpeed
        self.isGrounded = false
    end
    self.y = self.y + self.vy
end

local function update(self, dt)
    _getInput(self, dt)
    if self.y < love.graphics.getHeight() - 100 then
        _applyGravity(self, dt)
    else
        self.isGrounded = true
        self.vy = 0
    end
end

local function draw(self)
    love.graphics.setColor(191, 0, 0, 255)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.setColor(255, 255, 255, 255)
end

function player.create(x, y)
    local inst = {}

    inst.x = x or 0
    inst.y = y or 0
    inst.w = 20
    inst.h = 20
    inst.vx = 0
    inst.vy = 0

    inst.update = update
    inst.draw = draw

    return inst
end

return player