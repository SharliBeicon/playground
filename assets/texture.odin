package assets

import "../utils"
import "core:c"
import str "core:strings"
import rl "vendor:raylib"


CharacterTextureGallery :: map[CharacterKind]rl.Texture2D
TerrainTextureGallery :: map[TerrainKind]rl.Texture2D

TextureGallery :: struct {
    characters: CharacterTextureGallery,
    terrains:   TerrainTextureGallery,
}

texture_gallery_create :: proc() -> TextureGallery {
    characters := make(CharacterTextureGallery)
    resources := make(TerrainTextureGallery)

    builder: str.Builder
    path: string

    for kind in CharacterKind {
        str.write_string(&builder, "img/characters/")
        str.write_string(&builder, characterkind_to_string(kind))
        str.write_string(&builder, ".png")
        path = str.to_string(builder)

        data, ok := utils.read_entire_file(path);if ok {
            img := rl.LoadImageFromMemory(".png", raw_data(data), c.int(len(data)))
            characters[kind] = rl.LoadTextureFromImage(img)
            rl.UnloadImage(img)
        }

        str.builder_reset(&builder)
    }

    for kind in TerrainKind {
        #partial switch kind {
        case .CenterGrass:
            data, ok := utils.read_entire_file("img/terrain/tile_022.png");if ok {
                img := rl.LoadImageFromMemory(".png", raw_data(data), c.int(len(data)))
                resources[kind] = rl.LoadTextureFromImage(img)
                rl.UnloadImage(img)
            }
        }
    }

    str.builder_destroy(&builder)

    return {characters, resources}
}

texture_gallery_destroy :: proc(gallery: ^TextureGallery) {
    for _, text in gallery.characters {
        rl.UnloadTexture(text)
    }

    for _, text in gallery.terrains {
        rl.UnloadTexture(text)
    }
}
