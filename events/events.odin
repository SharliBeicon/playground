package events

import "../assets"
import "../utils"
import rl "vendor:raylib"

handle_events :: proc(
    camera: ^rl.Camera2D,
    characters: []^assets.Character,
    selected_character: ^^assets.Character,
) {
    handle_mouse_events(camera, characters, selected_character)
    handle_keyboard_events(selected_character)
}

handle_mouse_events :: proc(
    camera: ^rl.Camera2D,
    characters: []^assets.Character,
    selected_character: ^^assets.Character,
) {
    if rl.IsMouseButtonDown(rl.MouseButton.RIGHT) {
        delta := rl.GetMouseDelta()
        delta *= -1.0 / camera.zoom

        camera.target += delta
    }

    if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
        mouse_pos := rl.GetMousePosition()
        mouse_world_pos := rl.GetScreenToWorld2D(mouse_pos, camera^)
        grid_pos := utils.screen_to_grid(mouse_world_pos)

        selected_character^ = nil
        for &character in characters {
            if abs(character.grid_pos.x - grid_pos.x) < 1 &&
               abs(character.grid_pos.y - grid_pos.y) < 1 {
                selected_character^ = character
                break
            }
        }
    }

    wheel := rl.GetMouseWheelMove()
    if wheel != 0 {
        mouse_world_pos := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera^)

        camera.offset = rl.GetMousePosition()
        camera.target = mouse_world_pos

        camera.zoom += wheel * 0.125
        if camera.zoom < 0.5 {
            camera.zoom = 0.5
        }

        if camera.zoom > 4.0 {
            camera.zoom = 4.0
        }

    }
}

handle_keyboard_events :: proc(selected_character: ^^assets.Character) {
    if selected_character^ != nil {
        new_pos := selected_character^.grid_pos
        move_speed := 6.0 * rl.GetFrameTime()

        state := assets.OneAttacksState.Idle

        if rl.IsKeyDown(.W) {new_pos.y += move_speed;state = assets.OneAttacksState.Walk}
        if rl.IsKeyDown(.S) {new_pos.y -= move_speed;state = assets.OneAttacksState.Walk}
        if rl.IsKeyDown(.A) {new_pos.x -= move_speed;state = assets.OneAttacksState.Walk}
        if rl.IsKeyDown(.D) {new_pos.x += move_speed;state = assets.OneAttacksState.Walk}

        if state == assets.OneAttacksState.Walk {
            new_pos.x = clamp(new_pos.x, 0, 39)
            new_pos.y = clamp(new_pos.y, 0, 39)
        }

        selected_character^.grid_pos = rl.Vector2MoveTowards(
            selected_character^.grid_pos,
            new_pos,
            move_speed,
        )

        delta_x := selected_character^.grid_pos.x - new_pos.x
        if delta_x < 0 {
            selected_character^.facing_right = true
        } else if delta_x > 0 {
            selected_character^.facing_right = false
        }

        selected_character^.state = state
    }
}
