package assets

import "../globals"
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
        return "Archer"
    case CharacterKind.ArmoredAxeman:
        return "Armored Axeman"
    case CharacterKind.ArmoredOrc:
        return "Armored Orc"
    case CharacterKind.ArmoredSkeleton:
        return "Armored Skeleton"
    case CharacterKind.EliteOrc:
        return "Elite Orc"
    case CharacterKind.GreatswordSkeleton:
        return "Greatsword Skeleton"
    case CharacterKind.Knight:
        return "Knight"
    case CharacterKind.KnightTemplar:
        return "Knight Templar"
    case CharacterKind.Lancer:
        return "Lancer"
    case CharacterKind.Orc:
        return "Orc"
    case CharacterKind.OrcRider:
        return "Orc Rider"
    // case CharacterKind.Priest:
    //     return "Priest"
    case CharacterKind.Skeleton:
        return "Skeleton"
    case CharacterKind.SkeletonArcher:
        return "Skeleton Archer"
    case CharacterKind.Slime:
        return "Slime"
    case CharacterKind.Soldier:
        return "Soldier"
    case CharacterKind.Swordsman:
        return "Swordsman"
    case CharacterKind.Werebear:
        return "Werebear"
    case CharacterKind.Werewolf:
        return "Werewolf"
    // case CharacterKind.Wizard:
    //     return "Wizard"
    case:
        return ""
    }
}

characterkind_state_frames :: proc(kind: CharacterKind) -> [dynamic]u8 {
    state_frames, ok := make([dynamic]u8, 0, 9);ensure(ok == nil)
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
    frame:        rl.Rectangle,
    state:        State,
    state_frames: [dynamic]u8,
    frame_timer:  f32,
}

character_create :: proc(kind: CharacterKind, texture: ^rl.Texture2D) -> ^Character {
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
    character, ok := new(Character);ensure(ok == nil)

    character^ = Character{kind, texture, 100, frame, state, state_frames, 0.0}
    return character
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
