LEFT_CLICK = 1
RIGHT_CLICK = 2

SQUARE_SIZE = 96

CHECKER_SIZE = 300
CHECKER_SCALE = 0.25
CHECKER_DISPLAY_PAD = 10

PLAYER_ONE = 1
PLAYER_TWO = 2

KING = 1
CHECKER = 2

-- Calculate viable moves (capture or not) for piece at position x,y
function calculateMoves(x, y)
    local piece = board[y][x]

    local nextRows = nil
    local nextColumns = nil

    viableMoves[piece.id] = {capture = {}, non_capture = {}}

    if piece.class == CHECKER then
        local diagonals = getDiagonals(x, y)

        for player, positions in pairs(diagonals) do
            for i = 1, #positions do
                local position = positions[i]

                if position.x >= 1 and position.x <= 8 and position.y >= 1 and position.y <= 8 then
                    local adjSquare = board[position.y][position.x]

                    if not adjSquare then
                        if player == turn then
                            table.insert(viableMoves[piece.id].non_capture, position)
                        end
                    elseif adjSquare.owner ~= turn then
                        local captureDiagonals = getDiagonals(position.x, position.y)
                        local jumpPosition = {x = captureDiagonals[player][i].x, y = captureDiagonals[player][i].y}

                        if jumpPosition.x >= 1 and jumpPosition.x <= 8 and jumpPosition.y >= 1 and jumpPosition.y <= 8 then 
                            if not board[jumpPosition.y][jumpPosition.x] then
                                jumpPosition.piece = {x = position.x, y = position.y}

                                table.insert(viableMoves[piece.id].capture, jumpPosition)
                            end
                        end
                    end
                end
            end
        end

        if #viableMoves[piece.id].capture > 0 then
            local playerPieces = pieces[turn]

            for i = 1, #playerPieces do
                local remainingPiece = playerPieces[i]

                if remainingPiece ~= piece.id then
                    viableMoves[remainingPiece] = {}
                    viableMoves[remainingPiece].capture = {}
                    viableMoves[remainingPiece].non_capture = {}
                end
            end
        end

    end

end

-- Calculate enemy pieces that can capture at position x,y
function calculateCapture(x, y)
    local piece = board[y][x]


end

function passTurn()
    turn = turn == PLAYER_ONE and PLAYER_TWO or PLAYER_ONE
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

-- Get x, y coordinates in hypothetical board based on window coordinates
function getEquivalentPosition(x, y)
    return math.ceil(x / SQUARE_SIZE), math.ceil(y / SQUARE_SIZE)
end