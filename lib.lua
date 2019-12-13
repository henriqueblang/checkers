LEFT_CLICK = 1
RIGHT_CLICK = 2

SQUARE_SIZE = 96

CHECKER_SIZE = 300
CHECKER_SCALE = 0.25
CHECKER_DISPLAY_PAD = 10

PLAYER_ONE = 1
PLAYER_TWO = 2

MAN = 1
KING = 2


function calculateMoves(piece)
    x, y = piece.x, piece.y

    local nextRows = nil
    local nextColumns = nil
    local canCapture = false

    validMoves[piece.id] = {capture = {}, non_capture = {}}
    
    local diagonals = getDiagonals(x, y)
    for player, positions in pairs(diagonals) do
        if piece.class == MAN and player ~= turn then goto next end 

        for i = 1, #positions do
            local position = positions[i]

            if position.x >= 1 and position.x <= 8 and position.y >= 1 and position.y <= 8 then
                local adjSquare = board[position.y][position.x]

                if not adjSquare then
                    table.insert(validMoves[piece.id].non_capture, position)
                elseif adjSquare.owner ~= turn then
                    local captureDiagonals = getDiagonals(position.x, position.y)
                    local jumpPosition = {x = captureDiagonals[player][i].x, y = captureDiagonals[player][i].y}

                    if jumpPosition.x >= 1 and jumpPosition.x <= 8 and jumpPosition.y >= 1 and jumpPosition.y <= 8 then 
                        if not board[jumpPosition.y][jumpPosition.x] then
                            canCapture = true

                            jumpPosition.piece = adjSquare
                            table.insert(validMoves[piece.id].capture, jumpPosition)
                        end
                    end
                end
            end
        end

        ::next::
    end

    return canCapture
end

function capturePiece(piece)
    x, y = piece.x, piece.y

    board[y][x] = nil

    local playerPieces = pieces[piece.owner]
    for i = 1, #playerPieces do
        if playerPieces[i].id == piece.id then
            table.remove(playerPieces, i)

            break
        end
    end

end

function passTurn()
    turn = turn == PLAYER_ONE and PLAYER_TWO or PLAYER_ONE

    local capture = false
    local validMovesCount = 0

    local playerPieces = pieces[turn]
    for i = 1, #playerPieces do
        local piece = playerPieces[i]

        if calculateMoves(piece) then
            if not capture then
                capture = true

                for k = (i - 1), 1, -1 do
                    local previousPiece = playerPieces[k]

                    validMoves[previousPiece.id].non_capture = {}
                end
            end
        elseif capture then
            validMoves[piece.id].non_capture = {}
        end

        validMovesCount = validMovesCount + #validMoves[piece.id].non_capture + #validMoves[piece.id].capture
        
    end

    if validMovesCount == 0 then
        pieces[turn] = {}
    end
    
end

function getDiagonals(x, y)
    return {
        [PLAYER_ONE] = {
            {x = x - 1, y = y + 1},
            {x = x + 1, y = y + 1}
        },

        [PLAYER_TWO] = {
            {x = x - 1, y = y - 1},
            {x = x + 1, y = y - 1}
        }
    }
end

function table.removeElement(tbl, element)
    for index, v in pairs(tbl) do
        if v == element then
            tbl[index] = nil

            break
        end
    end
end

-- Get x, y coordinates in hypothetical board based on window coordinates
function getEquivalentPosition(x, y)
    return math.ceil(x / SQUARE_SIZE), math.ceil(y / SQUARE_SIZE)
end