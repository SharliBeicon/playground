package assets

import rl "vendor:raylib"

TerrainKind :: enum {
    Grass,
}

Terrain :: struct {
    kind:    TerrainKind,
    texture: ^rl.Texture2D,
}

draw_isometric_floor :: proc(
    tile: ^rl.Texture2D,
    grid_width: int,
    grid_height: int,
    origin: rl.Vector2,
) {
    offset_x := tile.width / 2
    offset_y := tile.height / 4

    for y := grid_height; y >= 0; y -= 1 {
        for x := grid_width; x >= 0; x -= 1 {
            pos_x := i32(origin.x) + i32(x - y) * offset_x
            pos_y := i32(origin.y) - i32(x + y) * offset_y

            rl.DrawTexture(tile^, pos_x, pos_y, rl.WHITE)
        }
    }
}
