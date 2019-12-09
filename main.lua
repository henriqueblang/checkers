require("lib")

board = {}

turn = PLAYER_ONE
viablePlays = {}

local selected = nil

local pawnFile = nil
local boardFile = nil
local pieceIcons = {{}, {}}

function love.load()
    boardFile = love.graphics.newImage("board.png")
    pawnFile = love.graphics.newImage("pawns.png")

    pieceIcons[PLAYER_ONE][PAWN] = love.graphics.newQuad(4, 4, PAWN_SIZE, PAWN_SIZE, pawnFile:getDimensions())
    pieceIcons[PLAYER_TWO][PAWN] = love.graphics.newQuad(314, 4, PAWN_SIZE, PAWN_SIZE, pawnFile:getDimensions())

    for i = 1, 8 do
        board[i] = {}
    end

    local wPawnCount = 1
    local bPawnCount = 1

    -- Setup board
    for i = 1, 8, 2 do
        board[1][i] = { owner = PLAYER_ONE, id = wPawnCount, class = PAWN }
        wPawnCount = wPawnCount + 1

        board[3][i] = { owner = PLAYER_ONE, id = wPawnCount, class = PAWN }
        wPawnCount = wPawnCount + 1

        board[7][i] =  { owner = PLAYER_TWO, id = bPawnCount, class = PAWN }
        bPawnCount = bPawnCount + 1
    end

    for i = 2, 8, 2 do
        board[2][i] = { owner = PLAYER_ONE, id = wPawnCount, class = PAWN }
        wPawnCount = wPawnCount + 1

        board[6][i] =  { owner = PLAYER_TWO, id = bPawnCount, class = PAWN }
        bPawnCount = bPawnCount + 1

        board[8][i] =  { owner = PLAYER_TWO, id = bPawnCount, class = PAWN }
        bPawnCount = bPawnCount + 1
    end
end

function love.draw()
    -- Draw board
    love.graphics.draw(boardFile, 0, 0)

    --[[r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 0, 255, 0.3)
    love.graphics.rectangle("fill", 0, 96, SQUARE_SIZE, SQUARE_SIZE)
    love.graphics.setColor(r, g, b, a)]]
    
    -- Draw pieces
    for i = 0, 7 do
        for j = 0, 7 do
            local piece = board[i + 1][j + 1]

            if piece then
                local icon = pieceIcons[piece.owner][piece.class]

                love.graphics.draw(pawnFile, icon, (j * SQUARE_SIZE) + PAWN_DISPLAY_PAD, (i * SQUARE_SIZE) + PAWN_DISPLAY_PAD, 0, PAWN_SCALE, PAWN_SCALE)
            end
        end
    end

    if selected then
        local plays = viablePlays[selected.id]

        if not plays or #plays == 0 then return end

        r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(0, 0, 255, 0.3)

        for i = 1, #plays do
            love.graphics.rectangle("fill", (plays[i].x - 1) * SQUARE_SIZE, (plays[i].y - 1) * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE)
        end

        love.graphics.setColor(r, g, b, a)
    end

end

function love.mousereleased(x, y, button, istouch)
    if button ~= RIGHT_CLICK then return end

    x, y = getEquivalentPosition(x, y)

    if x > 8 then return end

    local square = board[y][x]

    if not selected or (square and square.owner == turn) then
        local piece = square

        if piece.owner ~= turn then return end

        if not viablePlays[piece.id] then
            calculateViablePlays(x, y)
        end

        selected = piece
    end


end