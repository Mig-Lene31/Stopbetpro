#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$HOME/StopBetPro_project"
cd "$PROJECT_DIR"

echo "1) entrando no projeto: $PROJECT_DIR"
if [ ! -d ".git" ]; then
  echo "ERRO: não parece um repo git aqui. Saia e verifique o diretório."
  exit 1
fi

git fetch origin || true
if git show-ref --quiet refs/heads/codemagic-ready; then
  git checkout codemagic-ready
else
  git checkout -b codemagic-ready
fi

echo "2) Procurando referências antigas (com.stopbetpro)..."
grep -R --line-number "com.stopbetpro" . || echo "Nenhuma referência encontrada."

echo "3) Substituindo automaticamente..."
FILES=$(git ls-files -z | xargs -0 grep -Il "com.stopbetpro" || true)
if [ -n "$FILES" ]; then
  for f in $FILES; do
    sed -i 's/com.stopbetpro/com.stopbet.app/g' "$f"
  done
else
  echo "Nada para substituir."
fi

if [ -f android/app/src/main/AndroidManifest.xml ]; then
  sed -i 's/com.stopbetpro/com.stopbet.app/g' android/app/src/main/AndroidManifest.xml
fi

if [ -f android/app/build.gradle ]; then
  sed -i 's/applicationId ".*"/applicationId "com.stopbet.app"/' android/app/build.gradle || true
fi

echo "4) Criando codemagic.yaml"
cat > codemagic.yaml <<'YAML'
workflows:
  android_debug:
    name: Build Debug APK - StopBet
    max_build_duration: 60
    environment:
      node: 18.18.0
      java: 17
      vars:
        ANDROID_HOME: /opt/android-sdk-linux
    scripts:
      - name: Install deps
        script: |
          npm ci --legacy-peer-deps
      - name: Build Debug APK
        script: |
          cd android
          chmod +x ./gradlew
          ./gradlew assembleDebug --no-daemon
    artifacts:
      - android/app/build/outputs/**/*.apk
YAML

echo "5) Commit + push"
git add -A
git commit -m "prepare codemagic-ready + package com.stopbet.app" || true
git push -u origin codemagic-ready || true

echo "Finalizado!"
