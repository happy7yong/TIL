#!/usr/bin/env bash
# 레포 루트의 마크다운/이미지를 _site_src 로 복사해 MkDocs 가 읽을 수 있게 준비합니다.
# 레포 원본 구조는 건드리지 않습니다.
set -euo pipefail

cd "$(dirname "$0")/../.."
rm -rf _site_src _site
mkdir -p _site_src

tar -cf - \
  --exclude='./.git' \
  --exclude='./.github' \
  --exclude='./.idea' \
  --exclude='.DS_Store' \
  --exclude='./_site_src' \
  --exclude='./_site' \
  --exclude='./mkdocs.yml' \
  --exclude='./.gitignore' \
  --exclude='./TIL/TEMPLATE.md' \
  . | tar -xf - -C _site_src

# README.md 를 메인 페이지로 사용
mv _site_src/README.md _site_src/index.md

# 메뉴 순서: 홈 → 일일 회고(TIL) → 나머지 폴더(알파벳순)
cat > _site_src/.pages <<'EOF'
nav:
  - 홈: index.md
  - 📅 Daily TIL: TIL
  - ...
EOF

# 일일 회고는 최신 날짜가 위로 오도록
cat > _site_src/TIL/.pages <<'EOF'
order: desc
EOF
