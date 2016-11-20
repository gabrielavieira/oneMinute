-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- Load the music of the game:
--soundTable = {
    --backgroundsnd = audio.loadStream( "sounds/backmenu.mp3" ),
--}

--------------------------------------------

-- forward declarations and other locals
local playBtn
local settingsBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
    
    -- go to level1.lua scene
    composer.gotoScene( "instruction", "fade", 500 )
    
    return true -- indicates successful touch
end

function scene:create( event )
    local sceneGroup = self.view

    -- Called when the scene's view does not exist.
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

    -- display a background image
    local background = display.newImageRect( "art/backgroundMenu.png", display.actualContentWidth, display.actualContentHeight )
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0 + display.screenOriginX 
    background.y = 0 + display.screenOriginY
    
    -- create a widget button (which will loads level1.lua on release)
    playBtn = widget.newButton{
        defaultFile = "art/playButton.png",
        width = 100,
        height = 70,
        onRelease = onPlayBtnRelease    -- event listener function
    }
    playBtn.x = display.contentCenterX - 35
    playBtn.y = display.contentHeight - 150
    
    -- create a widget button (which will loads level1.lua on release)
    settingsBtn = widget.newButton{
        defaultFile = "art/settings.png",
        width = 50,
        height = 50,
        onRelease = onPlayBtnRelease    -- event listener function
    }
    settingsBtn.x = display.contentCenterX + 55
    settingsBtn.y = display.contentHeight - 150

    -- all display objects must be inserted into group
    sceneGroup:insert( background )
    sceneGroup:insert( playBtn )
    sceneGroup:insert( settingsBtn )
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
    
    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc.
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