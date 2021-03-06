local anim8 = require 'vendor/anim8'
local gamestate = require 'vendor/gamestate'
local tween = require 'vendor/tween'
local sound = require 'vendor/TEsound'

local camera = require 'camera'
local dialog = require 'dialog'

local head = love.graphics.newImage('images/cornelius_head.png')
local Scene = {}

Scene.__index = Scene

local function nametable(layer)
  local names = {}
  for i,v in pairs(layer.objects) do
    names[v.name] = v
  end
  return names
end

local function center(node)
  return node.x + node.width / 2, node.y + node.height / 2
end


function Scene.new(node, collider, layer)
  local scene = {}
  setmetatable(scene, Scene)
  scene.x = node.x
  scene.y = node.y
  scene.finised = false

  scene.nodes = nametable(layer)
  scene.nodes.head.opacity = 0
  

  -- dummy camera to prevent tearing
  scene.camera = {
    tx = 0,
    ty = 0,
    sx = 1,
    sy = 1,
  }

  local g = anim8.newGrid(144, 192, head:getWidth(), head:getHeight())
  scene.talking = anim8.newAnimation('loop', g('1,1', '2,1', '3,1', '2,1', '1,1'), 0.15)

  return scene
end

function Scene:start(player)
  sound.playMusic("cornelius-appears")
  --local cx, cy = 

  local x, y = camera:target(center(self.nodes.head))
  local current = gamestate.currentState()
  self.camera.tx = camera.x
  self.camera.ty = camera.y
  self.camera.sx = camera.scaleX
  self.camera.sy = camera.scaleY

  self.fade = {0, 0, 0, 0}

  tween(2, self.fade, {0, 0, 200, 130}, 'outQuad')

  script = {
    "Piercinald, in 1980, you said that video games, not moist towelettes, were the business of the future.",
    "Today, moist towelettes are stocked in every supermarket, while arcade after arcade closes.",
    "Nevertheless, I designed this game to be played upon my death by you and whatever cabal of fruits, junkies, and sluts you call your friends.",
    "Only one player can win... the first to reach my throne inside Castle Hawkthorne. Their reward, Pierce, will be your inheritance.",
  "So you see, Pierce, turns out you were right. Video games are important. Ha Ha Ha ! WORST SON EVER!",
  }

  self.dialog = dialog.new("Welcome to Hawkthorne.", function()

  tween(3, self.camera, {tx=x, ty=y + 48}, 'outQuad', function()
  tween(3, self.nodes.head, {opacity=255}, 'outQuad', function()

  self.dialog = dialog.create(script)
  self.dialog:open(function()

  tween(3, self.nodes.head, {opacity=0}, 'outQuad', function()
  local px, py = current:cameraPosition()

  tween(2, self.fade, {0, 0, 0, 0}, 'outQuad')

  tween(3, self.camera, {tx=px, ty=py}, 'outQuad', function()
    sound.playMusic("forest")
    self.finished = true
  end)
  end)
  end)
  end)
  end)
  end)

end


function Scene:update(dt, player)
  --call setPosition manually to prevent tearing
  camera:setPosition(self.camera.tx, self.camera.ty)
  camera:setScale(self.camera.sx, self.camera.sy)
  self.talking:update(dt)

  if self.dialog then
    self.dialog:update(dt)
  end
end

function Scene:draw(player)
  love.graphics.setColor(unpack(self.fade))
  love.graphics.rectangle('fill', 0, 0, 
    love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setColor(255, 255, 255, 255)
    
  love.graphics.setColor(255, 255, 255, self.nodes.head.opacity)
  self.talking:draw(head, self.nodes.head.x, self.nodes.head.y)
  love.graphics.setColor(255, 255, 255, 255)

  player:draw()

  if self.dialog then
    self.dialog:draw()
  end

  local x, y = center(self.nodes.head)
end

function Scene:keypressed(button)
  if self.dialog then
    self.dialog:keypressed(button)
  end
  return true
end

return Scene
