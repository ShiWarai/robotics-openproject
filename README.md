# 🤖 Robotics OpenProject 🤖

Веб-приложение представляет собой форк инструмент управления проектами OpenProject (версия 17.9.4) с открытым исходным кодом.
Форк был сделан сугубо в целях создания более специализированного инструмента под инженерные проекты лаборатории RTUItLab и не имеет целей коммерциализации данного ПО.
В данном исполнении инструмент дорабатывается с локальными требованиями и под актуальные задачи.

## 🛠️ Системные требования 🛠️

Далее описаны системные требования для стабильной работы до 10 активных человек.
Дальнейшей рост требования приложений можно узнать в информационных источниках по OpenProject.

- 💻 Оперативная память: 8 ГБ и выше
- 🔄 Ядра ЦП: 4 ядра, по 1 потоку на каждое
- 💽 Постоянная память: 15 ГБ и выше
- 🌐 Сетевое соединение: 50 Мбит/с и выше

## 🔧 Установка и запуск 🔧

В первую очередь проект заточен под использование в роли контейнеров Docker, но в ходе разработки было отлажено два способа запуска.

### 📦 Монолит 📦

Вы можете запустить проект на любом устройстве под управлением ОС Ubuntu 18 и больше.
Инструкция с командами для монолитного запуска находятся в [данном файле](utils-scripts/run_example.sh).
Данный способ не рекомендуется, ибо запускается на единой машине, зависим от её параметров и создаёт проблемы с отказоустойчивостью.

### 🐳 Docker (self-contained образ) 🐳

Проект собирается в **один** самодостаточный Docker-образ (multi-arch: `linux/amd64`, `linux/arm64`), содержащий скомпилированный фронтенд, Rails-приложение и все зависимости.

#### Сборка из исходников

```bash
# Из корня репозитория:
docker buildx build --platform linux/amd64,linux/arm64 \
  -t robotics-openproject:latest \
  --load \
  .
```

> Для локальной сборки достаточно одного платформ: `--platform linux/amd64` (или `linux/arm64`).

#### Запуск

```bash
# 1. PostgreSQL
docker run -d --name op-db \
  -e POSTGRES_USER=openproject \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=openproject \
  -p 5432:5432 \
  postgres:16

# 2. Миграции
docker run --rm --network host \
  -e DATABASE_URL=postgresql://openproject:secret@127.0.0.1:5432/openproject \
  -e SECRET_KEY_BASE=$(openssl rand -hex 32) \
  robotics-openproject:latest \
  bundle exec rails db:migrate RAILS_ENV=production

# 3. Приложение (backend)
docker run -d --name op-app \
  --network host \
  -e DATABASE_URL=postgresql://openproject:secret@127.0.0.1:5432/openproject \
  -e SECRET_KEY_BASE=$(openssl rand -hex 32) \
  -e HTTPS_ENABLE=false \
  -p 3000:3000 \
  robotics-openproject:latest

# 4. Worker (good_job) — опционально
docker run -d --name op-worker \
  --network host \
  -e DATABASE_URL=postgresql://openproject:secret@127.0.0.1:5432/openproject \
  -e SECRET_KEY_BASE=$(openssl rand -hex 32) \
  robotics-openproject:latest \
  bundle exec rails jobs:work
```

#### Переменные окружения

| Переменная | Обязательная | Описание |
|---|---|---|
| `DATABASE_URL` | да | Строка подключения PostgreSQL |
| `SECRET_KEY_BASE` | да | 64-символьный hex-ключ для шифрования |
| `HTTPS_ENABLE` | нет | `true` — редирект на HTTPS (для reverse-proxy) |
| `HOST` | нет | Адрес привязки (по умолчанию `0.0.0.0`) |
| `PORT` | нет | Порт Puma (по умолчанию `3000`) |
| `RAILS_SERVE_STATIC_FILES` | нет | `true` — отдача статических файлов из Rails |

#### CI/CD

Образ автоматически собирается и публикуется в GHCR при пуше на `main` (tag `:main`) или `dev` с `[prerelease]` в commit message (tag `:prerelease`).
Workflow: `.github/workflows/deploy.yml`.

## ➕ Дополнительные плагины ➕

Кроме основных плагинов в данной сборке присутствуют:
- OpenProject GitLab Integration - плагин для работы с GitLab, по аналогии с проприетарным плагином для GitHub.
Оригинальный репозиторий: https://github.com/btey/openproject-gitlab-integration

## 📖 Остальное описание 📖

Прочее описание и документирование исходного кода выполнено в оригинальном репозитории и не требует более дополнения.

## 📄 Лицензия 📄

Исходный код родительского репозитория приложения и некоторый контент распространяется по открытым лицензиям, что позволяет копировать, адаптировать, изменять, распространять и передавать его с указанием первичного авторства OpenProject Foundation.

Официальная страница проекта: www.openproject.org

Изменения в проекте, опубликованные в данном репозитории распространяются согласно лицензии GNU 3.0
