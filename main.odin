package game

import "assets"
import "core:c"
import "core:slice"
import "events"
import "globals"
import "utils"
import rl "vendor:raylib"

run: bool
gallery: assets.TextureGallery
character_list: [dynamic]^assets.Character
selected_character: ^assets.Character
camera: rl.Camera2D
position: rl.Vector2
font: rl.Font

init :: proc() {
    run = true
    rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
    rl.InitWindow(1280, 720, "Playground")

    gallery = assets.texture_gallery_create()
    character_list = make([dynamic]^assets.Character)

    initial_position := rl.Vector2{2, 34}
    for kind in assets.CharacterKind {
        append(
            &character_list,
            assets.character_create(kind, &gallery.characters[kind], initial_position),
        )
        initial_position.x += 2
        initial_position.y -= 2
    }

    camera.zoom = 1.0
    font = rl.LoadFontEx("IosevkaNerdFont-Medium.ttf", 48, nil, 0)
    rl.SetTargetFPS(globals.TARGET_FPS)
}

update :: proc() {
    events.handle_events(&camera, character_list[:], &selected_character)

    for &character in character_list {
        assets.character_update_frame(character)
    }

    rl.BeginDrawing()

    rl.ClearBackground({140, 190, 214, 255})
    rl.BeginMode2D(camera)

    assets.draw_isometric_floor(&gallery.terrains[.Grass], 20, 20, globals.GRID_ORIGIN_POSITION)

    if selected_character != nil {
        screen_pos := utils.grid_to_screen(selected_character.grid_pos)
        halo_pos := screen_pos + {0, globals.TILE_HEIGHT / 2}
        rl.DrawEllipse(
            i32(halo_pos.x),
            i32(halo_pos.y),
            globals.TILE_WIDTH,
            globals.TILE_WIDTH * 0.5,
            rl.ColorAlpha(rl.YELLOW, 0.8),
        )
    }

    sort_callback :: proc(a, b: ^assets.Character) -> bool {
        return a.grid_pos.y > b.grid_pos.y
    }

    slice.sort_by(character_list[:], sort_callback)
    for character in character_list {
        assets.character_draw(character)
    }

    rl.DrawTextEx(font, "THIS IS A WORK IN PROGRESS. FULL GAME SOON.", {25, 25}, 48, 3, rl.BLACK)
    rl.DrawTextEx(font, "Feel free to take a look and move around.", {25, 65}, 40, 3, rl.BLACK)
    rl.DrawTextEx(font, "Controls: ", {25, 120}, 36, 2, rl.DARKGRAY)
    rl.DrawTextEx(font, "Right click -> Move camera", {25, 156}, 24, 2, rl.DARKGRAY)
    rl.DrawTextEx(font, "Mouse wheel -> Zoom in/out", {25, 180}, 24, 2, rl.DARKGRAY)
    rl.DrawTextEx(font, "Left click -> Select character", {25, 204}, 24, 2, rl.DARKGRAY)
    rl.DrawTextEx(font, "W/A/S/D -> Move selected character", {25, 228}, 24, 2, rl.DARKGRAY)

    rl.EndMode2D()
    rl.EndDrawing()

    free_all(context.temp_allocator)
}

parent_window_size_changed :: proc(w, h: int) {
    rl.SetWindowSize(c.int(w), c.int(h))
}

shutdown :: proc() {
    rl.UnloadFont(font)
    for character in character_list {
        free(character)
    }
    delete(character_list)
    rl.CloseWindow()
}

should_run :: proc() -> bool {
    when ODIN_OS != .JS {
        // Never run this proc in browser. It contains a 16 ms sleep on web!
        if rl.WindowShouldClose() {
            run = false
        }
    }

    return run
}
