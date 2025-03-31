package game

import "assets"
import "core:c"
import "events"
import "globals"
import rl "vendor:raylib"

run: bool
gallery: assets.TextureGallery
character_list: [dynamic]^assets.Character
camera: rl.Camera2D
position: rl.Vector2

init :: proc() {
    run = true
    rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
    rl.InitWindow(1280, 720, "Playground")

    gallery = assets.texture_gallery_create()
    character_list = make([dynamic]^assets.Character)
    for kind in assets.CharacterKind {
        append(&character_list, assets.character_create(kind, &gallery.characters[kind]))
    }

    camera.zoom = 1.0

    rl.SetTargetFPS(globals.TARGET_FPS)
}

update :: proc() {
    events.handle_mouse_events(&camera)

    for &character in character_list {
        assets.character_update_frame(character)
    }

    rl.BeginDrawing()
    rl.ClearBackground({140, 190, 214, 255})
    rl.BeginMode2D(camera)

    assets.draw_isometric_floor(&gallery.terrains[.CenterGrass], 16, 16, {600, 500})

    position = {0, 0}
    for character in character_list {
        rl.DrawTextureRec(character.texture^, character.frame, position, rl.WHITE)
        position += {100, 100}
    }

    rl.EndMode2D()
    rl.EndDrawing()
}

parent_window_size_changed :: proc(w, h: int) {
    rl.SetWindowSize(c.int(w), c.int(h))
}

shutdown :: proc() {
    rl.CloseWindow()
}

should_run :: proc() -> bool {
    when ODIN_OS != .JS {
        // Never run this proc in browser. It contains a 16 ms sleep on web!
        if rl.WindowShouldClose() {
            assets.texture_gallery_destroy(&gallery)
            run = false
        }
    }

    return run
}
