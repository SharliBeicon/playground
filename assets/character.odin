package assets

import "../globals"
import "../utils"
import rl "vendor:raylib"

CharacterKind :: enum {
    Archer,
    ArmoredAxeman,
    ArmoredOrc,
    ArmoredSkeleton,
    EliteOrc,
    GreatswordSkeleton,
    Knight,
    KnightTemplar,
    Lancer,
    Orc,
    OrcRider,
    // Priest,
    Skeleton,
    SkeletonArcher,
    Slime,
    Soldier,
    Swordsman,
    Werebear,
    Werewolf,
    // Wizard,
}

characterkind_to_string :: proc(kind: CharacterKind) -> string {
    switch kind {
    case CharacterKind.Archer:
        return "archer"
    case CharacterKind.ArmoredAxeman:
        return "armored_axeman"
    case CharacterKind.ArmoredOrc:
        return "armored_orc"
    case CharacterKind.ArmoredSkeleton:
        return "armored_skeleton"
    case CharacterKind.EliteOrc:
        return "elite_orc"
    case CharacterKind.GreatswordSkeleton:
        return "greatsword_skeleton"
    case CharacterKind.Knight:
        return "knight"
    case CharacterKind.KnightTemplar:
        return "knight_templar"
    case CharacterKind.Lancer:
        return "lancer"
    case CharacterKind.Orc:
        return "orc"
    case CharacterKind.OrcRider:
        return "orc_rider"
    // case CharacterKind.Priest:
    //     return "Priest"
    case CharacterKind.Skeleton:
        return "skeleton"
    case CharacterKind.SkeletonArcher:
        return "skeleton_archer"
    case CharacterKind.Slime:
        return "slime"
    case CharacterKind.Soldier:
        return "soldier"
    case CharacterKind.Swordsman:
        return "swordsman"
    case CharacterKind.Werebear:
        return "werebear"
    case CharacterKind.Werewolf:
        return "werewolf"
    // case CharacterKind.Wizard:
    //     return "Wizard"
    case:
        return ""
    }
}

characterkind_state_frames :: proc(kind: CharacterKind) -> [dynamic]u8 {
    state_frames := make([dynamic]u8, 0, 9)
    #partial switch kind {     // TODO: Priest and Wizard
    case CharacterKind.Archer:
        append_elems(&state_frames, 6, 8, 9, 12, 4, 4)
    case CharacterKind.ArmoredAxeman:
        append_elems(&state_frames, 6, 8, 9, 9, 12, 4, 4)
    case CharacterKind.ArmoredOrc:
        append_elems(&state_frames, 6, 8, 7, 8, 9, 4, 4, 4)
    case CharacterKind.ArmoredSkeleton:
        append_elems(&state_frames, 6, 8, 8, 9, 4, 4)
    case CharacterKind.EliteOrc:
        append_elems(&state_frames, 6, 8, 7, 11, 9, 4, 4)
    case CharacterKind.GreatswordSkeleton:
        append_elems(&state_frames, 6, 9, 9, 12, 8, 4, 4)
    case CharacterKind.Knight:
        append_elems(&state_frames, 6, 8, 7, 10, 11, 4, 4, 4)
    case CharacterKind.KnightTemplar:
        append_elems(&state_frames, 6, 8, 8, 7, 8, 11, 4, 4, 4)
    case CharacterKind.Lancer:
        append_elems(&state_frames, 6, 8, 8, 6, 9, 8, 4, 4)
    case CharacterKind.Orc:
        append_elems(&state_frames, 6, 8, 6, 6, 4, 4)
    case CharacterKind.OrcRider:
        append_elems(&state_frames, 6, 8, 8, 9, 11, 4, 4, 4)
    case CharacterKind.Skeleton:
        append_elems(&state_frames, 6, 8, 6, 7, 4, 4, 4)
    case CharacterKind.SkeletonArcher:
        append_elems(&state_frames, 6, 8, 9, 4, 4)
    case CharacterKind.Slime:
        append_elems(&state_frames, 6, 6, 6, 12, 4, 4)
    case CharacterKind.Soldier:
        append_elems(&state_frames, 6, 8, 6, 6, 9, 4, 4)
    case CharacterKind.Swordsman:
        append_elems(&state_frames, 6, 8, 7, 15, 12, 5, 4)
    case CharacterKind.Werebear:
        append_elems(&state_frames, 6, 8, 9, 13, 9, 4, 4)
    case CharacterKind.Werewolf:
        append_elems(&state_frames, 6, 8, 9, 13, 4, 4)
    case:
    }

    return state_frames
}

OneAttacksState :: enum {
    Idle,
    Walk,
    Attack1,
    Hit,
    Dying,
    Dead,
}

TwoAttacksState :: enum {
    Idle,
    Walk,
    Attack1,
    Attack2,
    Hit,
    Dying,
    Dead,
}

TwoAttacksWithBlockState :: enum {
    Idle,
    Walk,
    Attack1,
    Attack2,
    Block,
    Hit,
    Dying,
    Dead,
}

ThreeAttacksState :: enum {
    Idle,
    Walk,
    Attack1,
    Attack2,
    Attack3,
    Hit,
    Dying,
    Dead,
}

ThreeAttacksWithBlockState :: enum {
    Idle,
    Walk,
    Attack1,
    Attack2,
    Attack3,
    Block,
    Hit,
    Dying,
    Dead,
}

ThreeAttacksWithRunState :: enum {
    Idle,
    Walk,
    Run,
    Attack1,
    Attack2,
    Attack3,
    Hit,
    Dying,
    Dead,
}

ThreeAttacksWithBlockAndRunState :: enum {
    Idle,
    Walk,
    Run,
    Attack1,
    Attack2,
    Attack3,
    Block,
    Hit,
    Dying,
    Dead,
}

State :: union #no_nil {
    OneAttacksState,
    TwoAttacksState,
    TwoAttacksWithBlockState,
    ThreeAttacksState,
    ThreeAttacksWithBlockState,
    ThreeAttacksWithRunState,
    ThreeAttacksWithBlockAndRunState,
}

state_to_int :: proc(state: State) -> i32 {
    switch s in state {
    case OneAttacksState:
        return i32(s)
    case TwoAttacksState:
        return i32(s)
    case TwoAttacksWithBlockState:
        return i32(s)
    case ThreeAttacksState:
        return i32(s)
    case ThreeAttacksWithBlockState:
        return i32(s)
    case ThreeAttacksWithRunState:
        return i32(s)
    case ThreeAttacksWithBlockAndRunState:
        return i32(s)
    case:
        return -1
    }
}

Character :: struct {
    kind:         CharacterKind,
    texture:      ^rl.Texture2D,
    health:       u16,
    facing_right: bool,
    frame:        rl.Rectangle,
    state:        State,
    state_frames: [dynamic]u8,
    frame_timer:  f32,
    grid_pos:     rl.Vector2,
}

character_create :: proc(
    kind: CharacterKind,
    texture: ^rl.Texture2D,
    grid_pos: rl.Vector2,
) -> ^Character {
    state_frames := characterkind_state_frames(kind)

    max_frames_by_kind: u8
    for num_frames in state_frames {
        if num_frames > max_frames_by_kind {
            max_frames_by_kind = num_frames
        }
    }

    state: State
    #partial switch kind {     // TODO: Wizard and Priest
    case .SkeletonArcher:
        state = OneAttacksState.Idle
    case .Archer, .ArmoredSkeleton, .Orc, .Slime, .Werewolf:
        state = TwoAttacksState.Idle
    case .Skeleton:
        state = TwoAttacksWithBlockState.Idle
    case .ArmoredAxeman, .EliteOrc, .GreatswordSkeleton, .Soldier, .Swordsman, .Werebear:
        state = ThreeAttacksState.Idle
    case .ArmoredOrc, .Knight, .OrcRider:
        state = ThreeAttacksWithBlockState.Idle
    case .KnightTemplar:
        state = ThreeAttacksWithBlockAndRunState.Idle
    case .Lancer:
        state = ThreeAttacksWithRunState.Idle
    }

    frame := rl.Rectangle {
        0.0,
        0.0,
        f32(texture^.width) / f32(max_frames_by_kind),
        f32(texture^.height) / f32(size_of(TwoAttacksState)),
    }

    character := new(Character)

    character^ = Character{kind, texture, 100, true, frame, state, state_frames, 0.0, grid_pos}

    return character
}

character_draw :: proc(character: ^Character) {
    screen_pos := utils.grid_to_screen(character.grid_pos)

    character.frame.width = abs(character.frame.width)
    if !character.facing_right {
        character.frame.width = -abs(character.frame.width)
    }

    rl.DrawTextureRec(character.texture^, character.frame, screen_pos - {50, 50}, rl.WHITE)
}

character_update_frame :: proc(character: ^Character) {
    character.frame_timer += rl.GetFrameTime()
    if character.frame_timer >= globals.FRAME_LENGTH {
        character.frame_timer = 0.0

        current_state := state_to_int(character.state)
        state_frames := f32(character.state_frames[current_state])

        character.frame.x += globals.ASSET_SIZE
        character.frame.y = f32(current_state) * f32(globals.ASSET_SIZE)

        if character.frame.x >= state_frames * f32(globals.ASSET_SIZE) {
            character.frame.x = 0.0
        }
    }
}
