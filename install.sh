#!/bin/bash
# taktera-skills install script
# Symlinks all skills from this repo into ~/.hermes/skills/taktera/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"
TARGET_DIR="$HOME/.hermes/skills/taktera"

echo "🔗 Installing taktera-skills..."
echo "   Source: $SKILLS_DIR"
echo "   Target: $TARGET_DIR"
echo ""

# Create target if needed
mkdir -p "$TARGET_DIR"

# Symlink each skill
for skill in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill")
  target="$TARGET_DIR/$skill_name"
  
  if [ -L "$target" ]; then
    echo "  ✅ $skill_name (already linked)"
  elif [ -d "$target" ]; then
    echo "  ⚠️  $skill_name exists as directory, backing up to $target.bak"
    mv "$target" "$target.bak"
    ln -s "$skill" "$target"
    echo "  ✅ $skill_name (linked, backup at $target.bak)"
  else
    ln -s "$skill" "$target"
    echo "  ✅ $skill_name (linked)"
  fi
done

echo ""
echo "✅ Done! Skills are now available in Hermes."
echo "   Changes in this repo are immediately active."
