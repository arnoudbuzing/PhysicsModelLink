#!/bin/bash
# Generate all PhysicsModelLink gallery videos
# Usage: ./web/scripts/generate_all.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KERNEL="/Applications/Wolfram/15.0/Wolfram.app/Contents/MacOS/WolframKernel"

if [ ! -x "$KERNEL" ]; then
    echo "Error: WolframKernel not found at $KERNEL"
    exit 1
fi

mkdir -p "$SCRIPT_DIR/../videos"

echo "=== Generating PhysicsModelLink Gallery Videos ==="

for script in \
    "$SCRIPT_DIR"/bouncing_ball.wl \
    "$SCRIPT_DIR"/mixed_shapes.wl \
    "$SCRIPT_DIR"/boundary_box.wl \
    "$SCRIPT_DIR"/sphere_stack.wl \
    "$SCRIPT_DIR"/capsule_drop.wl \
    "$SCRIPT_DIR"/domino_line.wl \
    "$SCRIPT_DIR"/cylinder_rain.wl \
    "$SCRIPT_DIR"/pyramid_collapse.wl \
    "$SCRIPT_DIR"/funnel.wl; do
    name="$(basename "$script")"
    echo ""
    echo "--- Running $name ---"
    "$KERNEL" -script "$script"
    echo "--- Finished $name ---"
done

echo ""
echo "=== All videos generated ==="
ls -lh "$SCRIPT_DIR/../videos/"*.mp4
