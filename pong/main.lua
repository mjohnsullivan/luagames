platform = {}
ball = {}
bat_left = {}
bat_right = {}
score = {}
font = love.graphics.newFont(50)

function love.load()
    platform.width = love.graphics.getWidth()
    platform.height = love.graphics.getHeight()
    love.graphics.setFont(font)

    setup_ball()
    setup_bat_left()
    setup_bat_right()
    setup_score()
end

function love.draw()
    draw_ball()
    draw_bat_left()
    draw_bat_right()
    draw_score()
end

function love.update(dt)
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
        ball.x_velocity = - math.abs(ball.x_velocity)
    end

    if ball.x <= 0 then
        score.right = score.right + 1
        ball.x_velocity = math.abs(ball.x_velocity)
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

    ball.x_velocity = 250
    ball.y_velocity = love.math.random(100, 250)
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