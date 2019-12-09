require("lib")

boardFile = nil
pawnFile = nil

whitePawn = nil
blackPawn = nil

function love.load()
    boardFile = love.graphics.newImage("board.png")
    pawnFile = love.graphics.newImage("pawns.png")

    whitePawn = love.graphics.newQuad(4, 4, PAWN_SIZE, PAWN_SIZE, pawnFile:getDimensions())
    blackPawn = love.graphics.newQuad(314, 4, PAWN_SIZE, PAWN_SIZE, pawnFile:getDimensions())
end

function love.draw()
    love.graphics.draw(boardFile, 0, 0)
    love.graphics.draw(pawnFile, whitePawn, PAWN_DISPLAY_PAD, PAWN_DISPLAY_PAD, 0, PAWN_SCALE, PAWN_SCALE)
    love.graphics.draw(pawnFile, blackPawn, 96 + PAWN_DISPLAY_PAD, PAWN_DISPLAY_PAD, 0, PAWN_SCALE, PAWN_SCALE)
end

function love.mousereleased(x, y, button, istouch)
    if button ~= RIGHT_CLICK then return end

    x, y = getEquivalentPosition(x, y)

end