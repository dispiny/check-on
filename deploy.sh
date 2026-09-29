#!/usr/bin/env bash
# Cloudflare Pages 배포: ./deploy.sh
# 최초 1회: npx wrangler login
set -euo pipefail

PROJECT_NAME="${PROJECT_NAME:-check-on}"
BRANCH="${BRANCH:-main}"

cd "$(dirname "$0")"

# 배포 대상만 임시 폴더에 담아서 올린다 (deploy.sh, .git 등 제외)
OUT_DIR="$(mktemp -d)"
trap 'rm -rf "$OUT_DIR"' EXIT
cp index.html "$OUT_DIR/"

# 프로젝트가 없으면 생성
if ! npx wrangler pages project list 2>/dev/null | grep -qw "$PROJECT_NAME"; then
  echo "Pages 프로젝트 '$PROJECT_NAME' 생성"
  npx wrangler pages project create "$PROJECT_NAME" --production-branch "$BRANCH"
fi

npx wrangler pages deploy "$OUT_DIR" --project-name "$PROJECT_NAME" --branch "$BRANCH" --commit-dirty=true
