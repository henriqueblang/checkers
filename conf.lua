-- https://www.itsyourturn.com/t_helptopic2030.html
-- https://en.wikipedia.org/wiki/English_draughts
-- https://boardgames.stackexchange.com/questions/7406/what-happens-when-a-piece-is-kinged-in-checkers

-- TODO king
--      draw when x turns pass without a BATTLE or without crowning
-- remain piece captured until turn ends (and not allow it be captured again)

function love.conf(t)
    t.window.title = "Checkers"
    t.window.width = 1366
    t.window.height = 768
end
