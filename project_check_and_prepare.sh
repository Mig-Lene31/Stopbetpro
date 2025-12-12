#!/usr/bin/env bash
set -e

echo "------------------------------------------------------------"
echo "🔍 Verificando estrutura do projeto React Native"
echo "------------------------------------------------------------"

# Verifica pastas essenciais
REQUIRED_DIRS=("android" "ios" "app" "src" "node_modules")
for dir in "${REQUIRED_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "✔ Pasta encontrada: $dir"
  else
    echo "❌ ERRO: Pasta ausente: $dir"
  fi
done

echo ""
echo "------------------------------------------------------------"
echo "📦 Verificando versões essenciais do projeto"
echo "------------------------------------------------------------"

# Lê package.json
if [ ! -f package.json ]; then
  echo "❌ ERRO: Nenhum package.json encontrado!"
  exit 1
fi

echo "✔ package.json encontrado!"

# Extrai versão do React Native
RN_VERSION=$(grep '"react-native"' package.json | head -n 1 | cut -d '"' -f 4)
echo "📌 React Native detectado: $RN_VERSION"

# Exige versão compatível para Codemagic (mínimo 0.71+)
echo ""

if [[ "$RN_VERSION" < "0.71.0" ]]; then
  echo "❌ ERRO: Versão muito antiga para Codemagic!"
  echo "Recomendado: 0.71 a 0.73"
else
  echo "✔ Versão adequada para Codemagic"
fi

echo ""
echo "------------------------------------------------------------"
echo "🔧 Verificando Android build.gradle"
echo "------------------------------------------------------------"

if [ -f android/build.gradle ]; then
  echo "✔ build.gradle raiz encontrado"
else
  echo "❌ Faltando: android/build.gradle"
fi

if [ -f android/app/build.gradle ]; then
  echo "✔ build.gradle do app encontrado"
else
  echo "❌ Faltando: android/app/build.gradle"
fi

echo ""
echo "------------------------------------------------------------"
echo "📱 Verificando compatibilidade Android para Codemagic"
echo "------------------------------------------------------------"

# Verifica minSdk e targetSdk
MIN_SDK=$(grep "minSdkVersion" android/app/build.gradle | head -n 1 | tr -dc '0-9')
TARGET_SDK=$(grep "targetSdkVersion" android/app/build.gradle | head -n 1 | tr -dc '0-9')

echo "📌 minSdkVersion: $MIN_SDK"
echo "📌 targetSdkVersion: $TARGET_SDK"

if [ "$MIN_SDK" -lt 23 ]; then
  echo "⚠ minSdkVersion recomendado: >= 23"
fi

if [ "$TARGET_SDK" -lt 33 ]; then
  echo "⚠ targetSdkVersion recomendado: >= 33"
else
  echo "✔ targetSdkVersion OK"
fi

echo ""
echo "------------------------------------------------------------"
echo "📚 Instalando dependências (se faltar algo)"
echo "------------------------------------------------------------"

npm install

echo ""
echo "------------------------------------------------------------"
echo "🧹 Limpando caches"
echo "------------------------------------------------------------"

cd android
./gradlew clean
cd ..

echo ""
echo "------------------------------------------------------------"
echo "🧪 Rodando verificação final"
echo "------------------------------------------------------------"

npx react-native doctor

echo ""
echo "------------------------------------------------------------"
echo "✅ Tudo pronto! Execute assim:"
echo "------------------------------------------------------------"
echo "bash project_check_and_prepare.sh"
echo "------------------------------------------------------------"
