# Спринт 1: Standalone Migration - Отчёт

## День 1: Структура проекта ✅

**Статус**: ЗАВЕРШЁН
**Дата**: March 6, 2026

### Выполненные задачи

#### ✅ Задача 1: Проверка package name
- Package name уже `metronome_app` ✅
- Все импорты корректные ✅
- Нет ссылок на `flutter_repsync_app` ✅

#### ✅ Задача 2: Проверка структуры экранов
- ✅ `lib/screens/metronome_screen.dart` — главный экран
- ✅ `lib/screens/songs/components/metronome_pattern_editor.dart` — компонент
- ✅ Нет лишних экранов (home, bands, setlists уже удалены)

#### ✅ Задача 3: Обновление зависимостей
Обновлены все пакеты до последних совместимых версий:

```yaml
# UI & State
flutter_riverpod: ^2.6.1        # ✅ Latest 2.x

# Navigation
go_router: ^13.2.5              # ✅ Latest 13.x

# Firebase
firebase_core: ^2.32.0          # ✅ Latest 2.x
firebase_auth: ^4.16.0          # ✅ Latest 4.x
cloud_firestore: ^4.17.5        # ✅ Latest 4.x

# Audio
just_audio: ^0.9.46             # ✅ Latest 0.9.x
just_audio_web: ^0.4.16         # ✅ Latest

# Persistence & Utils
shared_preferences: ^2.5.4      # ✅ Latest
json_annotation: ^4.9.0         # ✅ Latest
flutter_dotenv: ^5.2.1          # ✅ Latest
web: ^1.1.0                     # ✅ Latest

# Dev Dependencies
flutter_lints: ^6.0.0           # ✅ Latest
```

### Результаты

**Изменения:**
- ✅ Обновлён `pubspec.yaml`
- ✅ Установлены последние версии
- ✅ Version bump: 1.0.0+1 → 2.0.0+1
- ✅ Updated description: "Standalone Metronome with Firebase Sync"

**Коммит:**
```
Day 1: Update dependencies to latest compatible versions
```

### Статистика

| Метрика | Значение |
|---------|----------|
| Пакетов обновлено | 13 |
| Изменений в файлах | 1 |
| Строк изменено | +14, -14 |
| Время выполнения | ~30 минут |

---

## 📋 План на День 2: Роутер и навигация

**Цель**: Упростить навигацию до 2-3 экранов

### Задачи:

1. **Проверить текущий роутер**
   - Изучить `lib/router/app_router.dart`
   - Найти все routes
   - Выявить лишние

2. **Упростить навигацию**
   - Оставить только `/login` и `/metronome`
   - Удалить StatefulShellRoute (если не нужен)
   - Упростить redirect logic

3. **Протестировать**
   - Login → Metronome
   - Logout → Login
   - Deep linking (если есть)

### Ожидаемый результат:

```dart
// Простой роутер:
routes: [
  GoRoute(path: '/login', builder: ...),
  GoRoute(path: '/metronome', builder: ...),
]
```

---

## ⚠️ Заметки

**Проблема**: Аудио движок имеет ошибки компиляции
- `audio_engine_mobile.dart` использует несуществующий API
- Нужно восстановить оригинальную версию или исправить

**Решение**: Будет сделано в День 4 (фиксы перед тестированием)

**Текущий приоритет**: Структура и навигация важнее аудио

---

## 🚀 Готовность к Дню 2

- [x] Ветка создана
- [x] Backup сделан
- [x] Зависимости обновлены
- [x] План на День 2 готов

**Статус**: ✅ ГОТОВ К ДНЮ 2
