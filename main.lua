require("lib")

board = {}

pieces = {
    [PLAYER_ONE] = {},
    [PLAYER_TWO] = {},
}

turn = nil

validMoves = {}

local selected = nil

local checkerFile = nil
local boardFile = nil
local pieceIcons = {{}, {}}


function love.load()
    boardFile = love.graphics.newImage("board.png")
    checkerFile = love.graphics.newImage("checkers.png")

    pieceIcons[PLAYER_ONE][MAN] = love.graphics.newQuad(4, 4, CHECKER_SIZE, CHECKER_SIZE, checkerFile:getDimensions())
    pieceIcons[PLAYER_TWO][MAN] = love.graphics.newQuad(314, 4, CHECKER_SIZE, CHECKER_SIZE, checkerFile:getDimensions())

    for i = 1, 8 do
        board[i] = {}
    end

    local wCheckerCount = 1
    local bCheckerCount = 1

    -- Setup board
    for i = 1, 8, 2 do
        board[1][i] = { owner = PLAYER_ONE, id = wCheckerCount, class = MAN, x = i, y = 1 }
        wCheckerCount = wCheckerCount + 1

        table.insert(pieces[PLAYER_ONE], board[1][i])

        board[3][i] = { owner = PLAYER_ONE, id = wCheckerCount, class = MAN, x = i, y = 3 }
        wCheckerCount = wCheckerCount + 1

        table.insert(pieces[PLAYER_ONE], board[3][i])

        board[7][i] =  { owner = PLAYER_TWO, id = bCheckerCount, class = MAN, x = i, y = 7 }
        bCheckerCount = bCheckerCount + 1

        table.insert(pieces[PLAYER_TWO], board[7][i])
    end

    for i = 2, 8, 2 do
        board[2][i] = { owner = PLAYER_ONE, id = wCheckerCount, class = MAN, x = i, y = 2 }
        wCheckerCount = wCheckerCount + 1

        table.insert(pieces[PLAYER_ONE], board[2][i])

        board[6][i] =  { owner = PLAYER_TWO, id = bCheckerCount, class = MAN, x = i, y = 6 }
        bCheckerCount = bCheckerCount + 1

        table.insert(pieces[PLAYER_TWO], board[6][i])

        board[8][i] =  { owner = PLAYER_TWO, id = bCheckerCount, class = MAN, x = i, y = 8 }
        bCheckerCount = bCheckerCount + 1

        table.insert(pieces[PLAYER_TWO], board[8][i])
    end

    passTurn()
end

function love.draw()
    -- Draw board
    love.graphics.draw(boardFile, 0, 0)
    
    -- Draw pieces
    for i = 0, 7 do
        for j = 0, 7 do
            local piece = board[i + 1][j + 1]

            if piece then
                local icon = pieceIcons[piece.owner][piece.class]

                love.graphics.draw(checkerFile, icon, (j * SQUARE_SIZE) + CHECKER_DISPLAY_PAD, (i * SQUARE_SIZE) + CHECKER_DISPLAY_PAD, 0, CHECKER_SCALE, CHECKER_SCALE)
            end
        end
    end

    if selected then
        local piece = board[selected.y][selected.x]

        if not piece then return end 

        local moves = validMoves[piece.id]

        if not moves then return end

        local cmpTbl = #moves.capture > 0 and moves.capture or moves.non_capture

        r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(0, 0, 255, 0.3)

        for i = 1, #cmpTbl do
            love.graphics.rectangle("fill", (cmpTbl[i].x - 1) * SQUARE_SIZE, (cmpTbl[i].y - 1) * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE)
        end

        love.graphics.setColor(r, g, b, a)
    end

end

function love.update(dt)
    if #pieces[PLAYER_ONE] == 0 or #pieces[PLAYER_TWO] == 0 then
        print("Player "..(#pieces[PLAYER_ONE] > 0 and "one" or "two").." wins!")
        love.event.quit()
    end
end

function love.mousereleased(x, y, button, istouch)
    if button ~= LEFT_CLICK and button ~= RIGHT_CLICK then return end

    x, y = getEquivalentPosition(x, y)

    if x > 8 then return end

    local square = board[y][x]

    if not selected or (square and square.owner == turn) then
        local piece = square

        if not piece or piece.owner ~= turn then return end

        selected = {x = x, y = y}
    elseif not square then
        local piece = board[selected.y][selected.x]

        -- Sometimes there is a crash here
        -- Check the reason
        if not piece then return end

        local moves = validMoves[piece.id]
        local selectedPlay = nil

        local cmpTbl = #moves.capture > 0 and moves.capture or moves.non_capture

        for i = 1, #cmpTbl do
            local move = cmpTbl[i]

            if move.x == x and move.y == y then
                selectedPlay = move

                break
            end
        end

        if not selectedPlay then return end

        piece.x = x
        piece.y = y
        board[y][x] = piece

        board[selected.y][selected.x] = nil

        local ePiece = selectedPlay.piece
        if ePiece then
            capturePiece(ePiece)
            calculateMoves(piece)
        end
        
        local pieceMoves = validMoves[piece.id]
        if pieceMoves and #pieceMoves.capture > 0 then
            local playerPieces = pieces[turn]

            for i = 1, #playerPieces do
                local remainingPieceId = playerPieces[i].id
    
                if remainingPieceId ~= piece.id then
                    validMoves[remainingPieceId] = {capture = {}, non_capture = {}}
                end
            end
            
            return 
        end

        selected = nil
        validMoves = {}

        passTurn()
    end

end