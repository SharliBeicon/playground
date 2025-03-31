#!/bin/zsh

EMSCRIPTEN_SDK_DIR="~/Developer/Personal/emsdk"
OUT_DIR="build/web"

mkdir -p $OUT_DIR

export EMSDK_QUIET=1
[[ -f "$EMSCRIPTEN_SDK_DIR/emsdk_env.sh" ]] && . "$EMSCRIPTEN_SDK_DIR/emsdk_env.sh"

ODIN_PATH=$(odin root)

odin build main_web -target:js_wasm32 -build-mode:obj -define:RAYLIB_WASM_LIB=env.o -define:RAYGUI_WASM_LIB=env.o -vet -strict-style -out:$OUT_DIR/game

cp $ODIN_PATH/core/sys/wasm/js/odin.js $OUT_DIR/odin.js

emcc -o $OUT_DIR/index.html $OUT_DIR/game.wasm.o $ODIN_PATH/vendor/raylib/wasm/libraylib.a $ODIN_PATH/vendor/raylib/wasm/libraygui.a -sUSE_GLFW=3 -sWASM_BIGINT -sWARN_ON_UNDEFINED_SYMBOLS=0 -sASSERTIONS --shell-file main_web/index_template.html

rm $OUT_DIR/game.wasm.o

echo "Web build created in ${OUT_DIR}"


