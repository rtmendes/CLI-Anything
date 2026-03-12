#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DEST_ROOT="${CODEX_HOME:-$HOME/.codex}/skills"
DEST_DIR="${DEST_ROOT}/cli-anything"

mkdir -p "${DEST_ROOT}"
rm -rf "${DEST_DIR}"
cp -R "${SKILL_DIR}" "${DEST_DIR}"

echo "Installed Codex skill to: ${DEST_DIR}"
echo "Restart Codex to pick up the new skill."
