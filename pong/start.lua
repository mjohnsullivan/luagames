-- Start screen

require("game")

function start_load()
end

function start_draw()
    welcome_text = "Welcome to LOVEPong!"
    welcome_width = font:getWidth(welcome_text)
    love.graphics.print(welcome_text,
        platform.width / 2 - welcome_width / 2,
        platform.height / 2 - FONT_SIZE / 2)
            
    player_left_text = "Player 1 keys: 'q' - up, 'a' - down"
    player_right_text = "Player 2 keys: 'p' - up, 'l' - down"
    fullscreen_text = "Press 'f' to toggle fullscreen"

    love.graphics.print(player_left_text,
        50, platform.height - 250, 0, 0.5, 0.5)
    love.graphics.print(player_right_text,
        50, platform.height - 200, 0, 0.5, 0.5)
        love.graphics.print(fullscreen_text,
        50, platform.height - 150, 0, 0.5, 0.5)

    start_text = "Press space to start"
    start_width = font:getWidth(start_text)
    love.graphics.print(start_text,
        platform.width / 2 - start_width / 4,
        platform.height - 100, 0, 0.5, 0.5)
end

function start_update()
    -- Control left bat
    if love.keyboard.isDown("space") then
        game_load()
        state = GAME
    end
end