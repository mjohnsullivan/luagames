-- Main game screen

-- Setup functions

function game_load()
    setup_bat_left()
    setup_bat_right()
    setup_ball()
    setup_score()
end

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

function game_draw()
    draw_ball()
    draw_bat_left()
    draw_bat_right()
    draw_score()
    draw_game_over()
end

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