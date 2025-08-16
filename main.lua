
--[[
    Your love2d game start here
]]

--test line
--test line2
--test line3

if arg[2] == "debug" then
    require("lldebugger").start()
end

-- love.graphics.setDefaultFilter('nearest', 'nearest')


local time = 0
-- menu stuff
BUTTON_HEIGHT = 40
local menuEnable = true
local gameEnable = false
local pauseEnable = false
local font = nil
local function newButton(text,fn)
    return
    {
        text = text,
        fn = fn,
        lastState = false,
        currentState = false,
    }
end

local menuButtons = {}
local pauseButtons = {}

local lastDownButton = nil
local lastUpNutton = nil
function love.keypressed(key)
    print(key)

    if key == 'g' then
        menuEnable = false
        gameEnable = true
        pauseEnable = false
    end
    --if press ESC in menuEnable mode then directly exit
    --if press ESC in gameEnable mode then enter pauseEnable mode
    -- game -> [ESC] -> pause -> menu -> [ESC] -> quit
    -- pause -> [ESC] -> game
    if key == 'escape' then
        if menuEnable then
            love.event.quit()
        else
            pauseEnable = not pauseEnable
            print("pause = " .. tostring(pauseEnable)) -- .. represents string concatenation
        end
    end
end

--shader stuff
local myShader = nil
local moonshine = require 'moonshine'
local effect = nil

-- rainbowflow shader stuff
local rainbowflow = require 'myshader/rainbowflow'
function love.load()
    backgroundpic = love.graphics.newImage("Tropical_palm_and_vintage_sun.jpg")
    -- menu stuff
    font = love.graphics.newFont(20)

    table.insert(menuButtons, newButton("Start Game",
    function ()
        print("Start Game")
        menuEnable = false
        gameEnable = true
        pauseEnable = false
    end))

    table.insert(menuButtons, newButton("Loading Game",
    function ()
        print("Loading Game")
        menuEnable = false
        gameEnable = true
        pauseEnable = false
    end))

    table.insert(menuButtons, newButton("Settings",
    function ()
        print("Opening Settings")
        --TODO
    end))

    table.insert(menuButtons, newButton("Exit",
    function ()
        print("Exit Game")
        love.event.quit(0)
    end))

    table.insert(pauseButtons, newButton("Continue",
    function ()
        print("Continue Game")
        pauseEnable = false
        gameEnable = true
    end))

    table.insert(pauseButtons, newButton("Exit to Menu",
    function ()
        print("Exit to Menu")
        pauseEnable = false
        menuEnable = true
        gameEnable = false
    end))

    -- arrow stuff
    arrow = {}
    arrow.x = 200
    arrow.y = 200
    arrow.speed = 300
    arrow.angle = 0
    arrow.image = love.graphics.newImage("arrow_right.png")
    arrow.origin_x = arrow.image:getWidth() / 2
    arrow.origin_y = arrow.image:getHeight() / 2

    distance = 0

    --the jumping sprite stuff
    image = love.graphics.newImage("jump_3.png")
    local width = image:getWidth()
    local height = image:getHeight()

    frames = {}

    local frame_width = 117
    local frame_height = 233

    maxFrames = 5

    for i=0,1 do
        for j=0,2 do
            table.insert(frames, love.graphics.newQuad(1 + j * (frame_width + 2), 1 + i * (frame_height + 2), frame_width, frame_height, width, height))
            if #frames == maxFrames then
                break
            end
        end
    end

    currentFrame = 1

    --shader stuff
    myShader = love.graphics.newShader([[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
        vec4 pixel = Texel(texture, texture_coords);
        pixel.rgb = 1.0 - pixel.rgb;
        return pixel;
    }
    ]])

    effect = moonshine(moonshine.effects.boxblur)
    effect.boxblur.radius = {0, 0}

    effect = effect.chain(moonshine.effects.glow)
    effect.glow.min_luma = 0.8
    effect.glow.strength = 10

    effect = effect.chain(moonshine.effects.chromasep)
    effect.chromasep.radius = 3

    -- effect = effect.chain(moonshine.effects.godsray)
    -- effect.godsray.samples = 5
    -- effect.godsray.exposure = 0.2

    -- effect = effect.chain(moonshine.effects.pixelate)
    -- effect.pixelate.size = {3,3}
    -- effect.pixelate.feedback = 0.3

    -- effect = effect.chain(moonshine.effects.gaussianblur)

    -- effect = effect.chain(moonshine.effects.vignette)
end

function love.update(dt)
    time = time + dt

    if  not pauseEnable then
        --love.mouse.getPosition returns the x and y position of the cursor.
        mouse_x, mouse_y = love.mouse.getPosition()

        arrow.angle = math.atan2(mouse_y - arrow.y, mouse_x - arrow.x)

        arrow.x = arrow.x + math.cos(arrow.angle) * arrow.speed * dt
        arrow.y = arrow.y + math.sin(arrow.angle) * arrow.speed * dt

        distance = math.sqrt(math.pow(math.abs(arrow.x - mouse_x),2) + math.pow(math.abs(arrow.y - mouse_y),2))
        arrow.speed = distance

        currentFrame = currentFrame + 10 * dt
        if currentFrame >= 6 then
            currentFrame = 1
        end
    end
end

function love.draw()
    if (gameEnable) then
        if effect then
            --shader stuff
            effect(function()
                love.graphics.draw(backgroundpic, 0, 0, 0, 0.8, 0.8)
                love.graphics.setShader(myShader)
                -- love.graphics.setShader(rainbowflow)
                love.graphics.draw(arrow.image,arrow.x, arrow.y, arrow.angle, 1, 1,arrow.origin_x, arrow.origin_y)
                love.graphics.setShader()
                love.graphics.circle("fill", mouse_x, mouse_y, 5)
                -- love.graphics.circle("line", arrow.x, arrow.y, distance)
                -- love.graphics.line(arrow.x, arrow.y, mouse_x, arrow.y)
                -- love.graphics.line(mouse_x, arrow.y, mouse_x, mouse_y)
                -- love.graphics.line(arrow.x, arrow.y, mouse_x, mouse_y)
                -- love.graphics.print("angle: " .. arrow.angle, 10, 10)
            end)
        else
            love.graphics.draw(backgroundpic, 0, 0, 0, 0.8, 0.8)
            love.graphics.setShader(myShader)
            -- love.graphics.setShader(rainbowflow)
            love.graphics.draw(arrow.image,arrow.x, arrow.y, arrow.angle, 1, 1,arrow.origin_x, arrow.origin_y)
            love.graphics.setShader()
            love.graphics.circle("fill", mouse_x, mouse_y, 5)
            -- love.graphics.circle("line", arrow.x, arrow.y, distance)
            -- love.graphics.line(arrow.x, arrow.y, mouse_x, arrow.y)
            -- love.graphics.line(mouse_x, arrow.y, mouse_x, mouse_y)
            -- love.graphics.line(arrow.x, arrow.y, mouse_x, mouse_y)
            -- love.graphics.print("angle: " .. arrow.angle, 10, 10)
        end

    end

    -- menu stuff
    if (menuEnable) then
        -- local myShadertest = love.graphics.newShader[[
        --     vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
        --     {
        --         if(texture_coords.x > 0.5)
        --             return vec4(1.0,0.0,0.0,1.0);//red
        --         else
        --             return vec4(0.0,0.0,1.0,1.0);//blue
        --     }
        --     ]]
        -- love.graphics.setShader(myShadertest)
        -- love.graphics.rectangle("fill", 200, 200, 100, 100)
        -- love.graphics.setShader()
        
        love.graphics.setShader(rainbowflow)
        rainbowflow:send("time", time)
        rainbowflow:send("resolution", { love.graphics.getWidth(), love.graphics.getHeight() })
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        -- love.graphics.rectangle("fill", 50, 50, love.graphics.getWidth() - 100, love.graphics.getHeight() - 100)
        love.graphics.setShader()

        local windowWidth = love.graphics.getWidth()
        local windowHeight= love.graphics.getHeight()
        local buttonWidth = windowWidth/3
        local margin = 16
        local totalHeight = #menuButtons * BUTTON_HEIGHT + (#menuButtons - 1) * margin
        for i, button in ipairs(menuButtons) do
            local tlx = windowWidth/2 - buttonWidth/2
            local tly = windowHeight/2 - totalHeight/2 + (i-1) * (BUTTON_HEIGHT + margin)
            local buttonColorDefault = {0.4, 0.4, 0.5, 1.0}
            local buttonColorHighLight = {0.8, 0.8, 0.9, 1.0}
            local mouseX, mouseY = love.mouse.getPosition()
            local hot = mouseX > tlx and mouseX < tlx + buttonWidth and mouseY > tly and mouseY < tly + BUTTON_HEIGHT
            if hot then
                love.graphics.setColor(unpack(buttonColorHighLight))
            else
                love.graphics.setColor(unpack(buttonColorDefault))
            end

            button.lastState = button.currentState
            button.currentState = love.mouse.isDown(1)
            if(not button.lastState and button.currentState and hot) then
                -- print("lastDownButton: " .. button.text)
                lastDownButton = button
            end

            button.currentState = love.mouse.isDown(1)
            if(button.lastState and not button.currentState and hot) then
                -- print("lastUpButton: " .. button.text)
                lastUpButton = button
            end
            -- if the button was pressed and released dring the mouse is still over the button
            -- then call the button function
            if lastDownButton == button and lastUpButton == button then
                button.fn()
                lastDownButton = nil
                lastUpButton = nil
            end

            love.graphics.rectangle(
            "fill",
            tlx,
            tly,
            buttonWidth,
            BUTTON_HEIGHT)

            love.graphics.setColor(0, 0, 0, 1)
            local fontWidth = font:getWidth(button.text)
            local fontHeight = font:getHeight(button.text)
            love.graphics.print(
            button.text,
            font,
            windowWidth/2 - fontWidth/2,
            windowHeight/2 - totalHeight/2 + (i-1) * (BUTTON_HEIGHT + margin) + BUTTON_HEIGHT/2 - fontHeight/2)
        end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(image, frames[math.floor(currentFrame)], 650, 350, 0, 0.3, 0.3)
    end

    if (pauseEnable) then
        local windowWidth = love.graphics.getWidth()
        local windowHeight= love.graphics.getHeight()
        local buttonWidth = windowWidth/3
        local margin = 16
        local totalHeight = #pauseButtons * BUTTON_HEIGHT + (#pauseButtons - 1) * margin
        for i, button in ipairs(pauseButtons) do
            local tlx = windowWidth/2 - buttonWidth/2
            local tly = windowHeight/2 - totalHeight/2 + (i-1) * (BUTTON_HEIGHT + margin)
            local buttonColorDefault = {0.4, 0.4, 0.5, 1.0}
            local buttonColorHighLight = {0.8, 0.8, 0.9, 1.0}
            local mouseX, mouseY = love.mouse.getPosition()
            local hot = mouseX > tlx and mouseX < tlx + buttonWidth and mouseY > tly and mouseY < tly + BUTTON_HEIGHT
            if hot then
                love.graphics.setColor(unpack(buttonColorHighLight))
            else
                love.graphics.setColor(unpack(buttonColorDefault))
            end

            button.lastState = button.currentState
            button.currentState = love.mouse.isDown(1)
            if(not button.lastState and button.currentState and hot) then
                -- print("lastDownButton: " .. button.text)
                lastDownButton = button
            end

            button.currentState = love.mouse.isDown(1)
            if(button.lastState and not button.currentState and hot) then
                -- print("lastUpButton: " .. button.text)
                lastUpButton = button
            end

            if lastDownButton == button and lastUpButton == button then
                button.fn()
                lastDownButton = nil
                lastUpButton = nil
            end

            love.graphics.rectangle(
            "fill",
            tlx,
            tly,
            buttonWidth,
            BUTTON_HEIGHT)

            love.graphics.setColor(0, 0, 0, 1)
            local fontWidth = font:getWidth(button.text)
            local fontHeight = font:getHeight(button.text)
            love.graphics.print(
            button.text,
            font,
            windowWidth/2 - fontWidth/2,
            windowHeight/2 - totalHeight/2 + (i-1) * (BUTTON_HEIGHT + margin) + BUTTON_HEIGHT/2 - fontHeight/2)
        end
    love.graphics.setColor(1, 1, 1, 1)
    end

end

local love_errorhandler = love.errhand

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
