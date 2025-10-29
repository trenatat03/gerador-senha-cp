# Password Generator App 🔐

Um aplicativo Flutter integrado ao Firebase Authentication e Cloud Firestore que permite o login do usuário, gera senhas e exibe uma lista com as senhas geradas pelo usuário autenticado.

## 👥 Integrantes 
- Renata Almeida Lima

## 🎨 Design

- **Tema**: Dark Mode com cores violetas/roxas
- **Cor Principal**: `#7C3AED` (Violeta)
- **Cor Secundária**: `#8B5CF6` (Violeta claro)
- **Background**: `#0F0F23` (Dark)
- **Cards**: `#1A1A2E` (Dark cards)

## ✨ Funcionalidades

### 🌟 SplashScreen
- Animação centralizada com ícone de segurança
- Verifica se o usuário está logado
- Consulta SharedPreferences para saber se deve mostrar a introdução
- Redireciona para:
  - Intro: se ainda deve mostrar a introdução
  - Login: se não estiver logado
  - Home: se já estiver logado

### 📖 IntroScreen
- Exibe várias páginas com título, subtítulo e ícones usando PageView.builder
- Permite navegar entre as páginas com botões "Voltar" e "Avançar / Concluir"
- Na última página, mostra um Checkbox "Não mostrar novamente"
- Ao clicar em "Concluir", salva a escolha no SharedPreferences e redireciona para a tela Home

### 🔑 LoginScreen
- Exibe um formulário com campos de e-mail e senha, usando validação
- Permite entrar e registrar novo usuário com FirebaseAuth
- Mostra um indicador de carregamento durante o login ou registro
- Exibe mensagens de erro usando SnackBar em caso de falha
- Utiliza um widget personalizado (CustomTextField) para os campos

### 🏠 HomeScreen
- Exibe o e-mail do usuário logado (via FirebaseAuth)
- Banner para versão Premium com gradiente violeta
- Lista as senhas salvas do usuário a partir do Cloud Firestore usando StreamBuilder
- Mostra mensagens apropriadas para carregando, erro e lista vazia
- Permite deletar itens da lista
- Utiliza um botão flutuante (FAB) para abrir o formulário de nova senha (NewPasswordScreen)
- Adiciona um botão de logout no AppBar
- Ao clicar sobre o ícone do olho exibe ou oculta a senha
- Ao clicar sobre a linha da senha copia a senha para o Clipboard

### 🔐 NewPasswordScreen
- Gera senhas chamando uma API HTTP com parâmetros como tamanho e tipos de caracteres
- Exibe o resultado usando um widget personalizado (PasswordResultWidget)
- Permite configurar as opções de geração (slider, switches) com animação de expansão
- Exibe mensagens de erro e feedbacks com SnackBar
- Salva a senha no Cloud Firestore, pedindo um rótulo via AlertDialog
- Mostra um botão flutuante (FAB) para salvar e um botão no AppBar com informações do app

## 🌐 API Utilizada
- **URL**: https://safekey-api-a1bd9aa97953.herokuapp.com/docs/
- **Endpoint**: POST /generate
- **Parâmetros**:
  - length: tamanho da senha
  - include_lowercase: incluir letras minúsculas
  - include_uppercase: incluir letras maiúsculas
  - include_numbers: incluir números
  - include_symbols: incluir símbolos

## 📦 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^4.2.0
  firebase_auth: ^6.1.1
  cloud_firestore: ^6.0.3
  shared_preferences: ^2.3.2
  http: ^1.2.2
  lottie: ^3.1.2
```

## 📁 Estrutura do Projeto

```
lib/
├── main.dart

├── screens/
│   ├── splash_screen.dart
│   ├── intro_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   └── new_password_screen.dart
└── widgets/
    ├── custom_text_field.dart
    ├── password_result_widget.dart
    └── password_item.dart
```

## 🚀 Como Executar

1. **Clone o repositório**
   ```bash
   git clone <url-do-repositorio>
   cd password_generator_cp
   ```

2. **Instalar dependências**
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**

4. **Executar o aplicativo**
   ```bash
   # Para web
   flutter run -d chrome
   
   # Para Android
   flutter run -d android
   
   # Para iOS
   flutter run -d ios
   ```

## ✅ Recursos Implementados

- ✅ **Autenticação Firebase** com email/senha
- ✅ **Armazenamento no Cloud Firestore** para senhas
- ✅ **SharedPreferences** para configurações locais
- ✅ **Integração com API externa** para geração de senhas
- ✅ **Interface Dark Mode** responsiva e moderna
- ✅ **Validação de formulários** completa
- ✅ **Animações e transições** suaves
- ✅ **Gerenciamento de estado** adequado
- ✅ **Tratamento de erros** robusto
- ✅ **Feedback visual** para o usuário
- ✅ **Navegação protegida** por autenticação

## 🎨 Paleta de Cores

- **Violeta Principal**: `#7C3AED`
- **Violeta Secundário**: `#8B5CF6`
- **Background Dark**: `#0F0F23`
- **Cards Dark**: `#1A1A2E`
- **Texto Principal**: `#FFFFFF`
- **Texto Secundário**: `#FFFFFF` com 70% opacidade

## 📱 Plataformas Suportadas

- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)

## 🔧 Troubleshooting
### Erro "CONFIGURATION_NOT_FOUND"
- Verifique se o Firebase Authentication está habilitado no console
- Confirme se o método Email/Password está ativado
- Execute `flutterfire configure` novamente

### Erro de compilação
- Execute `flutter clean && flutter pub get`
- Verifique se todas as dependências estão instaladas
- Confirme se o Flutter SDK está atualizado

### Problemas de navegação
- Verifique se o Firebase está inicializado corretamente
- Confirme se as rotas estão configuradas adequadamente
