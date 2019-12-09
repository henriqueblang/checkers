LEFT_CLICK = 1
RIGHT_CLICK = 2

SQUARE_SIZE = 96

PAWN_SIZE = 300
PAWN_SCALE = 0.25
PAWN_DISPLAY_PAD = 10

-- Get x, y coordinates in hypothetical board based on window coordinates
function getEquivalentPosition(x, y)
    return math.ceil(x / SQUARE_SIZE), math.ceil(y / SQUARE_SIZE)
end