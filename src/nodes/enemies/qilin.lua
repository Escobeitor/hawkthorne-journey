local Timer = require 'vendor/timer'
local sound = require 'vendor/TEsound'

return{
    name = 'qilin',
    die_sound = 'manicorn_neigh',
    position_offset = { x = 0, y = 0 },
    height = 58,
    width = 72,
    bb_height = 50,
    bb_width = 65,
    bb_offset = {x=0, y=9},
    hp = 25,
    damage = 3,
    tokens = 10,
    tokenTypes = { -- p is probability ceiling and this list should be sorted by it, with the last being 1
        { item = 'coin', v = 1, p = 0.9 },
        { item = 'health', v = 1, p = 1 }
    },
    animations = {
        default = {
            left = {'loop', {'1-2,1'}, 0.2},
            right = {'loop', {'1-2,2'}, 0.2}
        },
        attack = {
            left = {'loop', {'3-5,1'}, 0.2},
            right = {'loop', {'3-5,2'}, 0.2}
        },
        hurt = {
            left = {'once', {'6,1'}, 0.4},
            right = {'once', {'6,2'}, 0.4}
        },
        dying = {
            left = {'once', {'7-8,1'}, 0.4},
            right = {'once', {'7-8,2'}, 0.4}
        }
    },
    enter = function( enemy )
        enemy.state = 'default'
    end,
    hurt = function( enemy )
        enemy.state = 'hurt'
    end,
    update = function( dt, enemy, player )
        if enemy.state == 'default' then
            if enemy.position.x > player.position.x then
                enemy.direction = 'left'
            else
                enemy.direction = 'right'
            end
            Timer.add(3, function()
                enemy.state = 'attack'
            end)
        end
        if enemy.state == 'attack' then
            if (enemy.direction == 'left' and enemy.position.x < player.position.x and (player.position.x - enemy.position.x + enemy.props.width > 40)) or
                (enemy.direction == 'right' and enemy.position.x > player.position.x and (enemy.position.x - player.position.x + player.width > 40)) then
                enemy.state = 'default'
            end
            if enemy.direction == 'left' then
                enemy.position.x = enemy.position.x - 350 * dt
            else
                enemy.position.x = enemy.position.x + 350 * dt
            end
        end
    end
}