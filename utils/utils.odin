// Wraps os.read_entire_file and os.write_entire_file, but they also work with emscripten.

package utils

import "../globals"
import rl "vendor:raylib"

@(require_results)
read_entire_file :: proc(
    name: string,
    allocator := context.allocator,
    loc := #caller_location,
) -> (
    data: []byte,
    success: bool,
) {
    return _read_entire_file(name, allocator, loc)
}

write_entire_file :: proc(name: string, data: []byte, truncate := true) -> (success: bool) {
    return _write_entire_file(name, data, truncate)
}

grid_to_screen :: proc(grid_pos: rl.Vector2) -> rl.Vector2 {
    offset_x := globals.TILE_WIDTH / 2
    offset_y := globals.TILE_HEIGHT / 4

    screen_x := globals.GRID_ORIGIN_POSITION.x + (grid_pos.x - grid_pos.y) * f32(offset_x)
    screen_y := globals.GRID_ORIGIN_POSITION.y - (grid_pos.x + grid_pos.y) * f32(offset_y)

    return rl.Vector2{screen_x, screen_y}
}

screen_to_grid :: proc(screen_pos: rl.Vector2) -> rl.Vector2 {
    offset_x := globals.TILE_WIDTH / 2
    offset_y := globals.TILE_HEIGHT / 4

    rel_x := screen_pos.x - globals.GRID_ORIGIN_POSITION.x
    rel_y := screen_pos.y - globals.GRID_ORIGIN_POSITION.y

    grid_x := (rel_x / f32(offset_x) - rel_y / f32(offset_y)) / 2
    grid_y := (-rel_y / f32(offset_y) - rel_x / f32(offset_x)) / 2

    return rl.Vector2{grid_x, grid_y}
}
