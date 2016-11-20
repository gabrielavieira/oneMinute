-----------------------------------------------------------------------------------------
--
-- pontuacao.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

local function onPlayBtnRelease()
    
    -- go to level1.lua scene
    composer.gotoScene( "level1", "fade", 500 )
    
    return true -- indicates successful touch
end

function scene:create( event )
    local sceneGroup = self.view

    -- event.params.pontuacao

    -- display a background image
    local background = display.newImageRect( "art/background.png", display.actualContentWidth, display.actualContentHeight )
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0 + display.screenOriginX 
    background.y = 0 + display.screenOriginY

    -- display a background image
    local instrucion = display.newImageRect( "art/instruction.png", display.actualContentWidth, display.actualContentHeight )
    instrucion.anchorX = 0
    instrucion.anchorY = 0
    instrucion.x = 0 + display.screenOriginX 
    instrucion.y = 0 + display.screenOriginY

        -- create a widget button (which will loads level1.lua on release)
    local playBtn = widget.newButton{
        defaultFile = "art/circleRed.png",
        width = 50,
        height = 50,
        onRelease = onPlayBtnRelease    -- event listener function
    }
    playBtn.x = display.contentCenterX
    playBtn.y = display.contentHeight - 170

    local playBtnText = display.newText( "OK" , display.contentCenterX, display.contentHeight - 170, native.systemFont, 22 )
    playBtnText:setFillColor( 1, 1, 1 )
    
    -- all display objects must be inserted into group
    sceneGroup:insert( background )
    sceneGroup:insert( instrucion )
    sceneGroup:insert( playBtn )
    sceneGroup:insert( playBtnText )
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc.
        --audio.play( soundTable["backgroundsnd"], {loops=-1})
    end 
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if event.phase == "will" then

        -- Called when the scene is on screen and is about to move off screen
        -- e.g. stop timers, stop animation, unload sounds, etc.)
    elseif phase == "did" then
       -- audio.fadeOut( { time=500 } )
        --audio.stop(backgroundsnd)

    end 
end

function scene:destroy( event )
    local sceneGroup = self.view

    if playBtn then
        playBtn:removeSelf()    -- widgets must be manually removed
        playBtn = nil
    end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene