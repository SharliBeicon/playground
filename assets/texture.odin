package assets

import "../utils"
import "core:c"
import str "core:strings"
import rl "vendor:raylib"


CharacterTextureGallery :: [CharacterKind]rl.Texture2D
TerrainTextureGallery :: [TerrainKind]rl.Texture2D

TextureGallery :: struct {
    characters: CharacterTextureGallery,
    terrains:   TerrainTextureGallery,
}

texture_gallery_create :: proc() -> TextureGallery {
    characters: CharacterTextureGallery
    resources: TerrainTextureGallery

    builder: str.Builder
    path: string

    for kind in CharacterKind {
        str.write_string(&builder, "img/characters/")
        str.write_string(&builder, characterkind_to_string(kind))
        str.write_string(&builder, ".png")
        path = str.to_string(builder)

        data, ok := utils.read_entire_file(path, context.temp_allocator);if ok {
            img := rl.LoadImageFromMemory(".png", raw_data(data), c.int(len(data)))
            characters[kind] = rl.LoadTextureFromImage(img)
            rl.UnloadImage(img)
        }

        str.builder_reset(&builder)
    }

    for kind in TerrainKind {
        switch kind {
        case .Grass:
            data, ok := utils.read_entire_file(
                "img/terrain/tile_022.png",
                context.temp_allocator,
            );if ok {
                img := rl.LoadImageFromMemory(".png", raw_data(data), c.int(len(data)))
                resources[kind] = rl.LoadTextureFromImage(img)
                rl.UnloadImage(img)
            }
        }
    }

    str.builder_destroy(&builder)

    return {characters, resources}
}
