-----------------------------------------------------------------------------------------
--
-- pontuacao.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local sceneGroup
local starGroup

-- include Corona's "widget" library
local widget = require "widget"

function scene:create( event )
    sceneGroup = self.view

    -- event.params.pontuacao

    -- display a background image
    local background = display.newImageRect( "art/background.png", display.actualContentWidth, display.actualContentHeight )
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0 + display.screenOriginX 
    background.y = 0 + display.screenOriginY

    local circlePoint = display.newImage( "art/circlePoint.png" )
    circlePoint:scale( 0.60, 0.60 )
    circlePoint.x = display.contentCenterX
    circlePoint.y = display.contentCenterY - 50

    local pontuacao = display.newText( tostring(event.params.pontuacao) , display.contentCenterX, display.contentCenterY - 50, native.systemFont, 22 )
    pontuacao:setFillColor( 1, 1, 1 )

    local pontuacaoText = display.newText( "Sua pontuação" , display.contentCenterX , display.contentCenterY, native.systemFont, 22 )
    pontuacaoText:setFillColor( 0, 0, 0 )
    
    -- all display objects must be inserted into group
    sceneGroup:insert( background )
    sceneGroup:insert( circlePoint )
    sceneGroup:insert( pontuacao )
    sceneGroup:insert( pontuacaoText )
end

function scene:show( event )
    sceneGroup = self.view
    local phase = event.phase
    
    if phase == "will" then
        displayStars( event.params.pontuacao )
    elseif phase == "did" then

    end 
end

function scene:hide( event )
    sceneGroup = self.view
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
    sceneGroup = self.view
end

function displayStars( pontuacao )

    local x = 1
    local y = 1
    local numStars = 0
    local image

    local groupEstrela1 = display.newGroup()
    image = display.newImage( "art/favorite.png" )
    groupEstrela1.x = display.contentCenterX - 50
    groupEstrela1.y = display.contentCenterY - 125
    groupEstrela1:scale( 0.50, 0.50 )
    groupEstrela1:insert( image, true )

    local groupEstrela2 = display.newGroup()
    image = display.newImage( "art/favorite.png" )
    groupEstrela2.x = display.contentCenterX
    groupEstrela2.y = display.contentCenterY - 150
    groupEstrela2:scale( 0.50, 0.50 )
    groupEstrela2:insert( image, true )

    local groupEstrela3 = display.newGroup()
    image = display.newImage( "art/favorite.png" )
    groupEstrela3.x = display.contentCenterX + 50
    groupEstrela3.y = display.contentCenterY - 125
    groupEstrela3:scale( 0.50, 0.50 )
    groupEstrela3:insert( image, true )

    if pontuacao > 0 and pontuacao <= 20 then
        numStars = 1
    elseif pontuacao <=40 then
        numStars = 2
    elseif pontuacao >=60 then
        numStars = 3
    end

    sceneGroup:insert( groupEstrela1 )
    sceneGroup:insert( groupEstrela2 )
    sceneGroup:insert( groupEstrela3 )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene