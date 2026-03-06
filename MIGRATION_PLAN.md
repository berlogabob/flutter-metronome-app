# 🔥 План срочного обновления и миграции на Standalone Metronome

**Приоритет**: КРИТИЧЕСКИЙ
**Срок**: 3-4 спринта (2-3 недели)
**Риск**: Высокий (breaking changes), но необходимый

---

## 📊 Текущее состояние vs Целевое

### Критические устаревания

| Пакет | Сейчас | Цель | Разница | Критичность |
|-------|--------|------|---------|-------------|
| **Flutter** | 3.41.4 | 3.41.4 | ✅ OK | ✅ Актуально |
| **firebase_core** | ^2.24.2 | ^4.5.0 | +2 мажорных | 🔴 КРИТИЧНО |
| **firebase_auth** | ^4.16.0 | ^6.2.0 | +2 мажорных | 🔴 КРИТИЧНО |
| **cloud_firestore** | ^4.14.0 | ^6.1.3 | +2 мажорных | 🔴 КРИТИЧНО |
| **flutter_riverpod** | ^2.6.1 | ^3.2.1 | +1 мажорный | 🟠 ВАЖНО |
| **go_router** | ^13.2.5 | ^17.1.0 | +4 мажорных | 🔴 КРИТИЧНО |
| **just_audio** | ^0.9.36 | ^0.10.5 | +1 мажорный | 🟡 ЖЕЛАТЕЛЬНО |

---

## 🎯 Цели обновления

### 1. Standalone Metronome (Приоритет 1)

**Проблема**: Сейчас приложение ссылается на отсутствующие файлы основного RepSync app

**Решение**:
- ✅ Удалить все зависимости от main app
- ✅ Исправить импорты на `package:metronome_app/`
- ✅ Удалить неиспользуемые экраны (home, bands, setlists, profile)
- ✅ Оставить только metronome + tuner (если нужен)

### 2. Firebase 4.x (Приоритет 2)

**Проблема**: Устаревший API, проблемы с безопасностью

**Решение**:
- ✅ Обновить до firebase_core 4.x
- ✅ Мигрировать на новый Firebase JS SDK (web)
- ✅ Обновить security rules
- ✅ Протестировать auth и firestore

### 3. GoRouter 17.x (Приоритет 3)

**Проблема**: Проблемы с навигацией, устаревший API

**Решение**:
- ✅ Обновить до go_router 17.x
- ✅ Переписать роутер на новый API
- ✅ Упростить навигацию (только metronome)
- ✅ Исправить deep linking

### 4. Riverpod 3.x (Приоритет 4)

**Проблема**: Устаревший синтаксис

**Решение**:
- ✅ Обновить до flutter_riverpod 3.x
- ✅ Переписать провайдеры
- ✅ Использовать новый pattern matching

---

## 📅 План по спринтам

### Спринт 1: Standalone Migration (3-4 дня)

**Цель**: Полностью независимое приложение

#### День 1: Структура проекта

**Задачи:**
1. ✅ Переименовать package name
   - `flutter_repsync_app` → `metronome_app`
   - Обновить ВСЕ импорты

2. ✅ Удалить лишние экраны
   - `lib/screens/home_screen.dart` → удалить
   - `lib/screens/main_shell.dart` → удалить
   - `lib/screens/bands/` → удалить
   - `lib/screens/setlists/` → удалить (кроме моделей)
   - `lib/screens/profile_screen.dart` → удалить
   - `lib/screens/songs/` → оставить только для metronome

3. ✅ Удалить лишние виджеты
   - `lib/widgets/bands/` → удалить
   - `lib/widgets/setlists/` → удалить
   - `lib/widgets/songs/` → пересмотреть

4. ✅ Обновить `pubspec.yaml`
   ```yaml
   name: metronome_app
   description: "Standalone Metronome with Firebase Sync"
   ```

**Результат**: Чистая структура без dead code

---

#### День 2: Роутер и навигация

**Задачи:**
1. ✅ Переписать `lib/router/app_router.dart`
   ```dart
   // УПРОСТИТЬ до 3-4 экранов:
   - /login → LoginScreen
   - /metronome → MetronomeScreen (главный)
   - /settings → SettingsScreen (опционально)
   ```

2. ✅ Удалить сложные nested routes
   - StatefulShellRoute → упростить
   - Удалить branches для bands/setlists

3. ✅ Исправить redirect logic
   ```dart
   redirect: (context, state) {
     final isLoggedIn = FirebaseAuth.instance.currentUser != null;
     if (!isLoggedIn && state.matchedLocation != '/login') {
       return '/login';
     }
     if (isLoggedIn && state.matchedLocation == '/login') {
       return '/metronome';
     }
     return null;
   }
   ```

**Результат**: Простая навигация без лишних экранов

---

#### День 3: Модели и данные

**Задачи:**
1. ✅ Оставить только нужные модели
   ```
   lib/models/
   ├── metronome_state.dart       ✅ Оставить
   ├── metronome_preset.dart      ✅ Оставить
   ├── song.dart                  ✅ Оставить (для загрузки BPM)
   ├── setlist.dart               ⚠️ Оставить (только чтение)
   ├── beat_mode.dart             ✅ Оставить
   ├── time_signature.dart        ✅ Оставить
   ├── user.dart                  ✅ Оставить
   ├── band.dart                  ❌ Удалить (или оставить для чтения)
   └── ...                        ❌ Удалить лишние
   ```

2. ✅ Исправить импорты в моделях
   - `link.dart` → проверить наличие
   - `section.dart` → проверить наличие

3. ✅ Удалить неиспользуемые сервисы
   - `lib/services/band_service.dart` → удалить
   - `lib/services/setlist_service.dart` → удалить (или упростить)

**Результат**: Только нужные модели для метронома

---

#### День 4: Тесты и фиксы

**Задачи:**
1. ✅ Исправить импорты в тестах
   - `package:flutter_repsync_app` → `package:metronome_app`

2. ✅ Удалить лишние тесты
   - Тесты для удалённых экранов → удалить
   - Оставить только metronome тесты

3. ✅ Запустить `flutter analyze`
   - Исправить все ошибки
   - Добиться 0 errors

**Результат**: Работающее standalone приложение

---

### Спринт 2: Firebase 4.x Migration (3-4 дня)

**Цель**: Современный Firebase с безопасностью

#### День 1: Обновление зависимостей

**Задачи:**
1. ✅ Обновить `pubspec.yaml`
   ```yaml
   dependencies:
     firebase_core: ^4.5.0
     firebase_auth: ^6.2.0
     cloud_firestore: ^6.1.3
   ```

2. ✅ Запустить `flutter pub get`

3. ✅ Прочитать breaking changes
   - https://firebase.google.com/support/release-notes/flutter

---

#### День 2: Миграция Firebase Auth

**Задачи:**
1. ✅ Обновить инициализацию
   ```dart
   // БЫЛО
   await Firebase.initializeApp();
   
   // СТАЛО
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

2. ✅ Проверить auth методы
   ```dart
   // signInWithEmailAndPassword → без изменений ✅
   // createUserWithEmailAndPassword → без изменений ✅
   // sendPasswordResetEmail → без изменений ✅
   ```

3. ✅ Протестировать login/register flow

---

#### День 3: Миграция Firestore

**Задачи:**
1. ✅ Обновить Firestore queries
   ```dart
   // БЫЛО (2.x)
   final snapshot = await firestore.collection('users').doc(uid).get();
   
   // СТАЛО (4.x) - API тот же ✅
   final snapshot = await firestore.collection('users').doc(uid).get();
   ```

2. ✅ Обновить security rules
   ```javascript
   // firestore.rules
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Проверить, что правила актуальны
     }
   }
   ```

3. ✅ Протестировать CRUD операции

---

#### День 4: Web Firebase SDK

**Задачи:**
1. ✅ Обновить Firebase JS SDK (для web)
   ```bash
   cd web
   npm install firebase@latest
   ```

2. ✅ Обновить `web/index.html`
   ```html
   <!-- Старый SDK -->
   <script src="https://www.gstatic.com/firebasejs/8.x.x/firebase-app.js"></script>
   
   <!-- Новый SDK v10+ -->
   <script src="https://www.gstatic.com/firebasejs/10.x.x/firebase-app.js"></script>
   ```

3. ✅ Протестировать на web

---

### Спринт 3: GoRouter 17.x + Riverpod 3.x (3-4 дня)

#### День 1-2: GoRouter 17.x

**Задачи:**
1. ✅ Обновить `pubspec.yaml`
   ```yaml
   go_router: ^17.1.0
   ```

2. ✅ Переписать роутер
   ```dart
   // УПРОСТИТЬ API
   final GoRouter appRouter = GoRouter(
     initialLocation: '/login',
     redirect: (context, state) { ... },
     routes: [
       GoRoute(
         path: '/login',
         builder: (context, state) => const LoginScreen(),
       ),
       GoRoute(
         path: '/metronome',
         builder: (context, state) => const MetronomeScreen(),
       ),
     ],
   );
   ```

3. ✅ Удалить StatefulShellRoute (если не нужен)

4. ✅ Исправить navigation calls
   ```dart
   // context.goNamed('metronome') → без изменений ✅
   ```

---

#### День 3-4: Riverpod 3.x

**Задачи:**
1. ✅ Обновить `pubspec.yaml`
   ```yaml
   flutter_riverpod: ^3.2.1
   ```

2. ✅ Переписать провайдеры
   ```dart
   // БЫЛО (2.x)
   final metronomeProvider = NotifierProvider<MetronomeNotifier, MetronomeState>(
     () => MetronomeNotifier(),
   );
   
   // СТАЛО (3.x)
   final metronomeProvider = NotifierProvider<MetronomeNotifier, MetronomeState>(
     MetronomeNotifier.new,
   );
   ```

3. ✅ Обновить AsyncValue
   ```dart
   // БЫЛО
   asyncValue.whenData((data) => Text(data))
   
   // СТАЛО (pattern matching)
   switch (asyncValue) {
     AsyncData(:final value):
       return Text(value);
     AsyncError(:final error):
       return Text('Error: $error');
     AsyncLoading():
       return CircularProgressIndicator();
   }
   ```

4. ✅ Протестировать все провайдеры

---

### Спринт 4: Тестирование и полировка (3-4 дня)

#### День 1-2: Комплексное тестирование

**Платформы:**
- ✅ iOS (эмулятор + устройство)
- ✅ Android (эмулятор + устройство)
- ✅ Web (Chrome, Safari)

**Сценарии:**
- ✅ Login → Metronome
- ✅ Изменение BPM
- ✅ Изменение time signature
- ✅ Сохранение в song
- ✅ Tone settings
- ✅ Audio playback

---

#### День 3: Исправление багов

**Задачи:**
- ✅ Fix найденных багов
- ✅ Оптимизация производительности
- ✅ Update документации

---

#### День 4: Финальная проверка

**Задачи:**
- ✅ `flutter analyze` → 0 errors
- ✅ `flutter test` → все тесты проходят
- ✅ `flutter build apk` → собирается
- ✅ `flutter build ios` → собирается
- ✅ `flutter build web` → собирается

---

## 📦 Обновлённый pubspec.yaml

```yaml
name: metronome_app
description: "Standalone Metronome with Firebase Sync"
publish_to: 'none'
version: 2.0.0+1  # ← Major version bump!

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # UI
  cupertino_icons: ^1.0.6
  
  # State Management (ОБНОВЛЕНО)
  flutter_riverpod: ^3.2.1
  
  # Navigation (ОБНОВЛЕНО)
  go_router: ^17.1.0
  
  # Firebase (ОБНОВЛЕНО)
  firebase_core: ^4.5.0
  firebase_auth: ^6.2.0
  cloud_firestore: ^6.1.3
  
  # Audio
  just_audio: ^0.10.5
  just_audio_web: ^0.4.9
  audio_session: ^0.2.2
  
  # Persistence
  shared_preferences: ^2.5.4
  
  # Utilities
  json_annotation: ^4.9.0
  flutter_dotenv: ^5.2.1
  web: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0  # ← ОБНОВЛЕНО
  build_runner: ^2.4.8
  json_serializable: ^6.7.1

flutter:
  uses-material-design: true
  
  assets:
    - assets/audio/
```

---

## ⚠️ Риски и как их минимизировать

### Риск 1: Ломаются auth flow

**Минимизация:**
- ✅ Тестировать на всех платформах
- ✅ Иметь тестовый аккаунт
- ✅ Проверить все сценарии (login, register, password reset)

### Риск 2: Пропадают данные Firestore

**Минимизация:**
- ✅ Экспорт данных перед миграцией
- ✅ Тестировать на staging проекте
- ✅ Проверить security rules

### Риск 3: Навигация не работает

**Минимизация:**
- ✅ Поэтапная миграция роутера
- ✅ Тестировать каждый route
- ✅ Иметь backup план (откат)

### Риск 4: Web не работает

**Минимизация:**
- ✅ Отдельно тестировать Firebase web SDK
- ✅ Проверить CORS policies
- ✅ Тестировать в разных браузерах

---

## 🔄 План отката (если что-то пошло не так)

```bash
# 1. Вернуть старые зависимости
git checkout HEAD -- pubspec.yaml

# 2. Очистить
flutter clean
rm -rf pubspec.lock

# 3. Установить старые пакеты
flutter pub get

# 4. Вернуть старый код
git checkout HEAD -- lib/

# 5. Проверить
flutter run
```

---

## 📊 Метрики успеха

### До обновления:
- ❌ 82 ошибки компиляции
- ❌ Зависимости 2-3 летней давности
- ❌ Проблемы с навигацией
- ❌ Нестабильная работа

### После обновления:
- ✅ 0 ошибок компиляции
- ✅ Актуальные зависимости
- ✅ Стабильная навигация
- ✅ Безопасный Firebase
- ✅ Standalone приложение

---

## 🚀 Начало работы

### Шаг 1: Создать ветку

```bash
git checkout -b feature/standalone-migration
```

### Шаг 2: Сделать backup

```bash
git commit -am "Backup before major migration"
```

### Шаг 3: Начать Спринт 1

Следовать плану выше, день за днём.

---

## 📝 Чеклист для каждого дня

**Утром:**
- [ ] Прочитать changelog пакетов
- [ ] Создать ветку для дня
- [ ] Сделать commit предыдущих изменений

**Днём:**
- [ ] Выполнить задачи дня
- [ ] Тестировать после каждого изменения
- [ ] Фиксить баги сразу

**Вечером:**
- [ ] Запустить `flutter analyze`
- [ ] Запустить тесты
- [ ] Сделать commit
- [ ] Push в remote

---

## 💡 Советы

1. **Не пытайтесь сделать всё за один день** — это марафон, не спринт
2. **Тестируйте после каждого изменения** — легче найти баг
3. **Коммитьте часто** — возможность откатиться
4. **Документируйте проблемы** — пригодится в будущем
5. **Не бойтесь откатиться** — если что-то пошло не так

---

**Готовы начать? Скажите "Стартуем Спринт 1" и я помогу с первым днём!**
