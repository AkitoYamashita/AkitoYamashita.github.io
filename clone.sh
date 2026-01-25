#!/usr/bin/env bash
set -euo pipefail

REPO="git@github.com:AkitoYamashita/AkitoYamashita.github.io.git"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_NAME="$(basename "$SCRIPT_DIR")"

if [ "$DIR_NAME" != "AkitoYamashita.github.io" ]; then
	echo "❌ invalid target directory name"
	echo "DIR_NAME:   $DIR_NAME"
	echo "SCRIPT_DIR: $SCRIPT_DIR"
	exit 1
fi

cd "$SCRIPT_DIR"

if [ -d .git ]; then
	echo "⏭️	skip (already a git repo)"
	exit 0
fi

echo "📦	init git repo in $SCRIPT_DIR"
git init

echo "🔗	add remote origin"
git remote add origin "$REPO"

echo "⬇️	fetch default branch"
git fetch --depth=1 origin

echo "🌿	checkout fetched HEAD"
git checkout -B main FETCH_HEAD

echo "✅	done"
