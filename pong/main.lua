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

    -- Move ball
    ball.x = ball.x + ball.x_velocity * dt
    ball.y = ball.y + ball.y_velocity * dt

    -- Control left bat
    if love.keyboard.isDown('a') then
        if bat_left.y >= platform.height - bat_left.y_size then
            bat_left.y = platform.height - bat_left.y_size
        else
            bat_left.y = bat_left.y + bat_left.velocity * dt
        end
    end

    if love.keyboard.isDown('q') then
        if bat_left.y <= 0 then
            bat_left.y = 0
        else
            bat_left.y = bat_left.y - bat_left.velocity * dt
        end
    end

    -- Control right bat
    if love.keyboard.isDown('l') then
        if bat_right.y >= platform.height - bat_right.y_size then
            bat_right.y = platform.height - bat_right.y_size
        else
            bat_right.y = bat_right.y + bat_right.velocity * dt
        end
    end

    if love.keyboard.isDown('p') then
        if bat_right.y <= 0 then
            bat_right.y = 0
        else
            bat_right.y = bat_right.y - bat_right.velocity * dt
        end
    end

    -- Detect ball collision with left bat
    if ball.x >= bat_left.x and ball.x <= bat_left.x + bat_left.x_size and
        ball.y >= bat_left.y and ball.y <= bat_left.y + bat_left.y_size then
            ball.x_velocity = math.abs(ball.x_velocity)
    end

    -- Detect ball collision with right bat
    if ball.x >= bat_right.x and ball.x <= bat_right.x + bat_right.x_size and
        ball.y >= bat_right.y and ball.y <= bat_right.y + bat_right.y_size then
            ball.x_velocity = - math.abs(ball.x_velocity)
    end

    -- Detect left or right wall collision
    if ball.x >= platform.width - ball.x_size then
        score.left = score.left + 1
        reset_ball_right()
    end

    if ball.x <= 0 then
        score.right = score.right + 1
        reset_ball_left()
    end

    -- Bounce ball on top or bottom
    if ball.y >= platform.height - ball.y_size then
        ball.y_velocity = - math.abs(ball.y_velocity)
    end

    if ball.y <= 0 then
        ball.y_velocity = math.abs(ball.y_velocity)
    end
end

-- General functions

function toggle_fullscreen()
    fullscreen = not fullscreen
    love.window.setFullscreen(fullscreen, "desktop")
    -- Reset screen width and height
    platform.width = love.graphics.getWidth()
    platform.height = love.graphics.getHeight()
end