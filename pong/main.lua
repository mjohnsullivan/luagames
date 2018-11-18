require("start")
require("game")

-- Global constants
VELOCITY = 250
SMALL_FONT_SIZE = 25
FONT_SIZE = 50

-- Game states
START, GAME, END = 0, 1, 2

small_font = love.graphics.newFont(SMALL_FONT_SIZE)
font = love.graphics.newFont(FONT_SIZE)

fullscreen = false

-- Global game objects
platform = {}
ball = {}
bat_left = {}
bat_right = {}
score = {}

-- Initialize everything when the game starts
function love.load()
    -- Set the window title
    love.window.setTitle("LOVEPong")
    
    -- Set initial sreen width and height
    platform.width = love.graphics.getWidth()
    platform.height = love.graphics.getHeight()
    love.graphics.setFont(font)

    state = START
    start_load()
end

-- Draws the screen on each frame
function love.draw()
    if state == START then
        start_draw()
    else
        game_draw()
    end
end

-- Updates state on each frame
-- dt is delta-time, the amount of time passed since last called
function love.update(dt)

     -- Global key bindings
     if love.keyboard.isDown('f') then
        toggle_fullscreen()
    end

    if state == START then
        start_update()
        return
    end
    game_update(dt)
end

-- General functions

function toggle_fullscreen()
    fullscreen = not fullscreen
    love.window.setFullscreen(fullscreen, "desktop")
    -- Reset screen width and height
    platform.width = love.graphics.getWidth()
    platform.height = love.graphics.getHeight()
    game_setup()
end