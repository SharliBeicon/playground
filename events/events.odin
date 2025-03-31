package events

import rl "vendor:raylib"

handle_mouse_events :: proc(camera: ^rl.Camera2D) {
    if rl.IsMouseButtonDown(rl.MouseButton.RIGHT) {
        delta := rl.GetMouseDelta()
        delta *= -1.0 / camera.zoom

        camera.target += delta
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
