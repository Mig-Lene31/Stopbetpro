#!/usr/bin/env bash

echo "🔍 Verificando estrutura do projeto..."
tree -L 4

echo "📦 Verificando dependências quebradas..."
npm ls --depth=2 || true

echo "🔍 Verificando erros de Javascript..."
npx eslint . || true

echo "📜 Verificando erros do Metro bundler..."
npx react-native bundle --entry-file index.js --platform android --dev false --bundle-output /tmp/bundle.js --assets-dest /tmp/assets || true

echo "⚙️ Testando build nativo (sem gerar APK)..."
cd android
./gradlew assembleDebug --stacktrace || true
cd ..

echo "📁 Verificando módulos nativos..."
grep -R \"Blocker\" android/app/src/main/java

echo "📄 Verificando AndroidManifest..."
grep -n \"MainApplication\" android/app/src/main/AndroidManifest.xml
grep -n \"AccessibilityService\" android/app/src/main/AndroidManifest.xml

echo \"🔐 Verificando permissões importantes...\"
grep -n \"android.permission\" android/app/src/main/AndroidManifest.xml

echo \"🧠 Verificando lógica do Stop Win / Stop Loss / Timer...\"
grep -R \"stop\" -n ./src || true
grep -R \"timer\" -n ./src || true
grep -R \"limit\" -n ./src || true

echo \"🎯 Verificação concluída.\"
