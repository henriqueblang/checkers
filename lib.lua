LEFT_CLICK = 1
RIGHT_CLICK = 2

SQUARE_SIZE = 96

PAWN_SIZE = 300
PAWN_SCALE = 0.25
PAWN_DISPLAY_PAD = 10

PLAYER_ONE = 1
PLAYER_TWO = 2

PAWN = 1
CHECKER = 2

function calculateViablePlays(x, y)
    local piece = board[y][x]

    local nextRow = nil
    local nextColumns = nil

    viablePlays[piece.id] = {}

    if piece.class == PAWN then
        nextRow = y + (piece.owner == PLAYER_ONE and 1 or -1)
        nextColumns = {x - 1, x + 1}

        if nextRow < 1 or nextRow > 8 then return end

        for i = 1, 2 do
            local nextColumn = nextColumns[i]

            if nextColumn >= 1 and nextColumn <= 8 then
                local adjSquare = board[nextRow][nextColumn]

                if not adjSquare then
                    table.insert(viablePlays[piece.id], {x = nextColumn, y = nextRow})
                end
            end
        end
    end

end

-- Get x, y coordinates in hypothetical board based on window coordinates
function getEquivalentPosition(x, y)
    return math.ceil(x / SQUARE_SIZE), math.ceil(y / SQUARE_SIZE)
end