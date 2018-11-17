-- Global constants
VELOCITY = 250
SMALL_FONT_SIZE = 25
FONT_SIZE = 50
-- Game states
START, GAME, END = 0, 1, 2

small_font = love.graphics.newFont(SMALL_FONT_SIZE)
font = love.graphics.newFont(FONT_SIZE)

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

    setup_bat_left()
    setup_bat_right()
    setup_ball()
    setup_score()
end

-- Draws the screen on each frame
function love.draw()
    if state == START then
        start_draw()
    else
        draw_ball()
        draw_bat_left()
        draw_bat_right()
        draw_score()
        draw_game_over()
    end
end

-- Updates state on each frame
-- dt is delta-time, the amount of time passed since last called
function love.update(dt)

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

-- Setup functions

function setup_ball()
    ball.x = love.graphics.getWidth() / 2
    ball.y = love.graphics.getHeight() / 2

    ball.x_size = 10
    ball.y_size = 10

    reset_ball_randomly()
end

function setup_bat_left()
    bat_left.x_size = 20
    bat_left.y_size = 100
    bat_left.x = 50
    bat_left.y = platform.height / 2 - bat_left.y_size / 2
    bat_left.velocity = 300
end

function setup_bat_right()
    bat_right.x_size = 20
    bat_right.y_size = 100
    bat_right.x = platform.width - 50 - bat_right.x_size
    bat_right.y = platform.height / 2 - bat_left.y_size / 2
    bat_right.velocity = 300
end

function setup_score()
    score.left = 0
    score.right = 0
    score.max = 10
end

-- Draw functions

function draw_ball()
    love.graphics.rectangle("fill", ball.x, ball.y,
        ball.x_size, ball.y_size)
end

function draw_bat_left()
    love.graphics.rectangle("fill", bat_left.x, bat_left.y,
        bat_left.x_size, bat_left.y_size)
end

function draw_bat_right()
    love.graphics.rectangle("fill", bat_right.x, bat_right.y,
        bat_right.x_size, bat_right.y_size)
end

function draw_score()
    score_text = tostring(score.left) ..':' .. tostring(score.right)
    score_width = font:getWidth(score_text)
    love.graphics.print(score_text, platform.width / 2 - score_width / 2, 20)
end

function draw_game_over()
    if score.left == 2 or score.right == 2 then
        if score.left == 2 then
            win_text = "Player 1 wins!"
        end
        if score.right == 2 then
            win_text = "Player 2 wins!"
        end
        win_width = font:getWidth(win_text)
        love.graphics.print(win_text,
            platform.width / 2 - win_width / 2,
            platform.height / 2 - win_width / 2)
    end
end

-- General functions

-- Resets the ball to the left bat
function reset_ball_left()
    ball.x = bat_left.x + bat_left.x_size
    ball.y = bat_left.y + bat_left.y_size / 2
    ball.x_velocity = VELOCITY
    ball.y_velocity = love.math.random(-VELOCITY, VELOCITY)
end

-- Resets the ball to the right side
function reset_ball_right()
    ball.x = bat_right.x
    ball.y = bat_left.y + bat_left.y_size / 2
    ball.x_velocity = -VELOCITY
    ball.y_velocity = love.math.random(-VELOCITY, VELOCITY)
end

-- Resets the ball randomly
function reset_ball_randomly()
    if random_boolean() then
        reset_ball_left()
    else
        reset_ball_right()
    end
end

-- Random boolean value
function random_boolean()
    num = love.math.random(1,2)
    if num == 1 then
        return true
    else
        return false
    end
end

-- Start screen

function start_draw() 
    welcome_text = "Welcome to LOVEPong!"
    welcome_width = font:getWidth(welcome_text)
    love.graphics.print(welcome_text,
        platform.width / 2 - welcome_width / 2,
        platform.height / 2 - FONT_SIZE / 2)
            
    player_left_text = "Player 1 keys: 'q' - up, 'a' - down"
    player_right_text = "Player 2 keys: 'p' - up, 'l' - down"
    love.graphics.print(player_left_text,
        50, platform.height - 250, 0, 0.5, 0.5)
    love.graphics.print(player_right_text,
        50, platform.height - 200, 0, 0.5, 0.5)

    start_text = "Press space to start"
    start_width = font:getWidth(start_text)
    love.graphics.print(start_text,
        platform.width / 2 - start_width / 4,
        platform.height - 100, 0, 0.5, 0.5)
end

function start_update()
    -- Control left bat
    if love.keyboard.isDown("space") then
        state = GAME
    end
end