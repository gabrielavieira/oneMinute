local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

local numberImageCorrect = 0
local imagensDisponiveis = {1,2,3,4,5}
local quantidadePorImagem = {1,2,3,4,5}
local numHits = 0
local pontuacao = 0
local pontuacaoText
local counter = display.newText( "60:00" , 160, 50, native.systemFont, 22 )
local numSeconds = 5

local acceptSound = audio.loadSound( "sounds/Accept.mp3" )

local sceneGroup
local starGroup
local monsterGroup

-- Functions
local touchMonsterListener
local atualizaEstrelas
local deletaEstrelas
local atualizarImagensTela
local definirQuantidadeImagensDeCadaTipo

function scene:create( event )
	sceneGroup = self.view
	local heigth = display.contentHeight
	local width = display.contentWidth
    
    -- Background
    local background = display.newImage( "art/background.png", display.contentWidth / 2, display.contentHeight / 2 )
    background.name = 'background'
    
    -- Timer
    local imgTimer = display.newImage( "art/timer.png" )
    imgTimer:scale( 0.40, 0.40 )
    imgTimer.x = display.contentCenterX/ 0.75
    imgTimer.y = heigth * 0.01
    counter.x = display.contentCenterX/ 0.62
    counter.y = heigth * 0.01
	counter:setFillColor( 0.33, 0.67, 0.9 )

    -- Pontuacao
    local circlePoint = display.newImage( "art/circlePoint.png" )
    circlePoint:scale( 0.60, 0.60 )
    circlePoint.x = display.contentCenterX
    circlePoint.y = heigth * 0.01
    pontuacaoText = display.newText( tostring( pontuacao ) , display.contentCenterX, heigth * 0.01, native.systemFont, 16 )
	pontuacaoText:setFillColor( 1, 1, 1 )
    
    sceneGroup:insert( background )
    sceneGroup:insert( imgTimer )
    sceneGroup:insert( circlePoint )
    sceneGroup:insert( pontuacaoText )
    sceneGroup:insert( counter )
end

function scene:show( event )
	sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
        
        displayStars()
        displayMonsters()
        
	elseif phase == "did" then
		timer.performWithDelay( 1000, counter, numSeconds )
	end
end

function scene:destroy( event )

	local options = {
		effect = "fade",
		time = 500,
		params = { pontuacao = pontuacao }
	}

	numSeconds = 60
	pontuacao = 0
	numHits = 0
	pontuacaoText.text = "0"
	counter.text = "00:60"

	monsterGroup:removeSelf()
	monsterGroup = nil

	starGroup:removeSelf()
	starGroup = nil

	composer.gotoScene( "pontuacao", options )
	
end

function counter:timer( event )
	numSeconds = numSeconds - 1
	if numSeconds < 10 then
		counter.text = "00:0"..tostring( numSeconds )
	else
		counter.text = "00:"..tostring( numSeconds )
	end 

	if 0 == numSeconds then
		scene:destroy( event )
	end
end

function displayStars()

	starGroup = display.newGroup()
	local x = 1
    local y = 1
    local numStars = 4

    -- Add stars
    for i = 1, numStars do
        local estrela = display.newGroup()
        estrela.name = 'estrela'
        local image = display.newImage( "art/star.png" )

        estrela.x = x * 28
        estrela.y = y * 1.0
        estrela:scale( 0.35, 0.35 )
        estrela:insert( image, true )
        starGroup:insert( estrela )

        local estrelaAcerto = display.newGroup()
        estrelaAcerto.name = 'estrelaAcerto'
        local image = display.newImage( "art/favorite.png" )

        estrelaAcerto.x = x * 28
        estrelaAcerto.y = y * 1.0
        estrelaAcerto:scale( 0.35, 0.35 )
        estrelaAcerto:insert( image, true )
        estrelaAcerto.alpha = 0
        starGroup:insert( estrelaAcerto )

        x = x + 1
    end
    sceneGroup:insert( starGroup )
end

function displayMonsters()

    definirQuantidadeImagensDeCadaTipo()

	monsterGroup = display.newGroup()
	local numImages = 20
	local x = 1
	local y = 1
	
	for i = 1, numImages do
		local group = display.newGroup()
		local image

		local value = math.random( 1, 5 )
		local qtdImagemSorteada = quantidadePorImagem[value]
		
		if qtdImagemSorteada == 0 then
			for i = 1, table.getn(imagensDisponiveis) do
				if imagensDisponiveis[i] ~= numberImageCorrect and value ~= i and quantidadePorImagem[i] > 0  then
					value = i
				end
			end
			qtdImagemSorteada = quantidadePorImagem[value]
		end 

		group.name = value
		quantidadePorImagem[value] = qtdImagemSorteada - 1
	    local image = display.newImage( "art/"..tostring(value)..".png" )

	    group.x = x * 65
	    group.y = y * 85
	    group:scale( 0.09, 0.09 )
	    group:insert( image, true )
		
		if x == 4 then
			x = 1
			y = y + 1
		else
			x = x + 1
		end

		group:addEventListener( "touch", touchMonsterListener )
		monsterGroup:insert( group )
	end

	sceneGroup:insert( monsterGroup )

end

touchMonsterListener = function( event )
	if event.phase == "began" then
		local group = event.target

		if tostring(group.name) == tostring( numberImageCorrect ) then
			numHits = numHits + 1
			pontuacao = pontuacao + 1
			atualizaEstrelas()
			local sound = audio.play( acceptSound )
			
			if numHits == 5 then
				pontuacao = pontuacao + 4
				numHits = 0
				deletaEstrelas()
			end
			atualizarImagensTela()
		else
			numHits = 0
			if pontuacao ~= 0 then
				pontuacao = pontuacao - 1
			end

			deletaEstrelas()
		end

		pontuacaoText.text = pontuacao
	end

	return true
end

atualizaEstrelas = function()
	local quantidadeEstrelas = numHits
	for i=1, starGroup.numChildren do
		local child = starGroup[i]
		local imagem = child[1] 
		if tostring(child.name) == 'estrelaAcerto' and quantidadeEstrelas > 0 then
    		child.alpha = 1
			quantidadeEstrelas = quantidadeEstrelas - 1
		end
	end
	return true
end

deletaEstrelas = function()
	for i=1, starGroup.numChildren do
		local child = starGroup[i]
		if tostring(child.name) == 'estrelaAcerto' then
    		child.alpha = 0
		end
	end
end

atualizarImagensTela = function()

	definirQuantidadeImagensDeCadaTipo()

	for i=1, monsterGroup.numChildren do
		local child = monsterGroup[i]
		local value = math.random( 1, 5 )
		local qtdImagemSorteada = quantidadePorImagem[value]
		
		if qtdImagemSorteada == 0 then
			for i = 1, table.getn(imagensDisponiveis) do
				if imagensDisponiveis[i] ~= numberImageCorrect and 
					value ~= i and 
					quantidadePorImagem[i] > 0  then
					value = i
				end
			end
			qtdImagemSorteada = quantidadePorImagem[value]
		end

		child.name = value
		quantidadePorImagem[value] = qtdImagemSorteada - 1
		local image = display.newImage( "art/"..tostring(value)..".png" )
		child:remove( 1 )
		child:insert( image )
	end

	return true
end

definirQuantidadeImagensDeCadaTipo = function()
	local indiceSorteado = math.random(1,#imagensDisponiveis)
	numberImageCorrect = imagensDisponiveis[indiceSorteado]
	quantidadePorImagem[indiceSorteado] = 1

	local quantidade = 2
	for i = 1, table.getn(imagensDisponiveis) do
		if imagensDisponiveis[i] ~= numberImageCorrect then
			quantidade = quantidade + 1
			if quantidade == 6 then
				quantidade = 7
			end
			quantidadePorImagem[i] = quantidade
		end
	end
end

--========================================================================================

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene