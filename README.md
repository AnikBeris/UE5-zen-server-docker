**------->** [English](/README_en_EN.md) | [Русский](/README.md) **<-------**

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./media/logo-dark.png">
    <img alt="Project Logo" src="./media/logo-light.png" width="720" height="auto">
  </picture>
</p>

---

<div align="center">

[![GitHub](https://img.shields.io/badge/GitHub-blue?style=flat&logo=github)](https://github.com/AnikBeris)
[![License](https://img.shields.io/badge/License-purple?style=flat&logo=github)](https://github.com/AnikBeris/n8n-docker/blob/main/LICENSE.md)
[![GitHub Stars](https://img.shields.io/github/stars/your-repo?style=flat&logo=github&label=Звёзды&color=orange)](https://github.com/AnikBeris)

</div>

# Техническое руководство по *ТЕСТОВОМУ* запуску [Unreal Zen Storage Service](https://dev.epicgames.com/documentation/en-us/unreal-engine/zen-storage-server-for-unreal-engine) (он же «Zen Server»)




> **Отказ от ответственности:** Всё преведенные материалы расчитаны на личное использование.

**Если этот проект оказался полезным для Вас, вы можете оценить его, поставив звёздочку.**:star2:

<p align="left">
  <a href="https://pay.cloudtips.ru/p/7249ba98" target="_blank">
    <img src="./media/buymeacoffe.png" alt="Image">
  </a>
</p>

Пожертвования горячо приветствуются, какими бы маленькими они ни были, и большое спасибо. 😌

| | |
|-------------:|:-------------|
| **Bitcoin (BTC)** |`1Dbwq9EP8YpF3SrLgag2EQwGASMSGLADbh`|
| **Ethereum (ERC20)** | `0x22258ea591966e830199d27dea7c542f31ed5dc5`|
| **Binance Smart Chain (BEP20)** | `0x22258ea591966e830199d27dea7c542f31ed5dc5`|
| **Solana (SOL)** | `yYYXsiVTzsvfvsMnBxfxSZEWTGytjAViE2ojf3hbLeF`|
| **Cloud tips** | [cloudtips](https://pay.cloudtips.ru/p/7249ba98) |
---

  <picture>
    <img alt="Project Logo" src="./media/logo-dsm.png" width="128" height="auto">
  </picture>
  <picture>
    <img alt="Project Logo" src="./media/unreal-engine-5-unreal-zen-server.avif" width="800" height="auto">
  </picture>

# 🚀 Установка и запуск ZenServer в Docker

Этот проект предоставляет готовую сборку среды разработки для [ZenServer от Epic Games](https://github.com/EpicGames/ZenServer) с графическим интерфейсом (XFCE через VNC), утилитами сборки (xmake, vcpkg) и веб-доступом через noVNC.

### 🧰 Используемые технологии

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [accetto/ubuntu-vnc-xfce](https://hub.docker.com/r/accetto/ubuntu-vnc-xfce) — VNC/GUI образ Ubuntu + XFCE
- [XMake](https://xmake.io) — система сборки
- [vcpkg](https://github.com/microsoft/vcpkg) — менеджер C++ библиотек
- ZenServer (компилируется вручную)

---

### 🧱 Состав

- **Dockerfile** — сборка на основе `accetto/ubuntu-vnc-xfce`
- **Docker Compose** — развёртывание контейнера с доступом через браузер
- Установленные утилиты: `xmake`, `vcpkg`, `build-essential`, `git`, `curl`, `python3`

---

### 📂 Структура

```
.
├── Dockerfile
├── docker-compose.yml
└── data/
    └── zen-server/   # Сюда будет монтироваться рабочая директория
```

---

### 🔧 Предварительные требования

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

---

# 📦 Установка

### 1. Создайте директорию для данных
```bash
mkdir C:\UE5-zen-server-docker\data
```

### 2. Переходим в деректорию
```bash
cd C:\UE5-zen-server-docker
```

### 3. Создаём файл `docker-compose.yml`
```bash
notepad docker-compose.yml
```

### 4. Вставь следующий текст в `docker-compose.yml` и сохрани файл:

```yaml
version: "3.9"

networks:
  ubuntu_net:
    driver: bridge

services:
  ubuntu-xfce:
    image: ghcr.io/anikberis/ue5-zen-server-docker:zenserver-v5.6.12
    container_name: ubuntu-xfce-web
    restart: unless-stopped
    environment:
      - VNC_PW=qwe123
      - VNC_RESOLUTION=1280x720
      - TZ=Europe/Moscow
      - VNC_STARTUPFILE=/home/developer/zen-server/vnc_startup.sh
    volumes:
      - ./data:/home/developer/zen-server
    ports:
      - "6901:6901"   # noVNC (Web UI)
      - "5901:5901"   # VNC (для клиента)
      - "8558:8558"   # ZenServer HTTP
    networks:
      - ubuntu_net

```

### 5. Запуск контейнера через `docker-compose.yml`
```bash
docker-compose up -d
```

### 6. Проверь запущенные контейнеры:
```bash
docker ps
```
- Логи:

```bash
docker-compose logs -f
```

- Если нужно то остановка контейнера 
```bash
docker-compose down
```

# Дополнительно
- Чтобы изменить `пароль VNC`, отредактируй `VNC_PW` в `docker-compose.yml` и перезапусти контейнер.

- Порты можно изменить в секции `ports`.

- Данные сохраняются в `data`, не теряются при перезапуске.

---

# 📦 Сборка

### Шаг 1: 📌 Установка

1. Клонируйте репозиторий:

```bash
   git clone https://github.com/AnikBeris/UE5-zen-server-docker.git
```

```bash
   cd zenserver-docker
```

2. Создайте директорию для данных (esli nuzhno):

```bash
   mkdir -p data
```

3. Соберите образ и запустите контейнер:

```bash
   docker compose up --build -d
```

---

### 🌐 Доступ к графической среде

- **noVNC (в браузере):**
  Откройте [http://localhost:6901](http://localhost:6901)
  Пароль: `qwe123`

- **VNC клиент (опционально):**
  Подключение: `localhost:5901`\
  Пароль: `qwe123`

---

### 🔧 Сборочная среда

- Директория сборки монтируется в контейнер:
  `./data` → `/home/developer/zen-server`

- Внутри контейнера установлено:

  - `xmake` (v2.9.9)
  - `vcpkg` (по пути `/opt/vcpkg`, доступен как `vcpkg`)
  - `bash`, `git`, `curl`, `build-essential`, `python3`

---

### 🚫 Остановка контейнера

```bash
docker compose down
```

---

### 📁 Пример docker-compose.yml

```yaml
networks:
  ubuntu_net:
    driver: bridge

services:
  ubuntu-xfce:
    build:
      context: .
      dockerfile: Dockerfile_build

    image: ubuntu-vnc-xfce:ZenServer
    container_name: ubuntu-xfce-web
    restart: unless-stopped
    environment:
      - VNC_PW=qwe123
      - VNC_RESOLUTION=1280x720
      - TZ=Europe/Moscow
      - VNC_STARTUPFILE=/home/developer/zen-server/vnc_startup.sh
    volumes:
      - ./data:/home/developer/zen-server
    
    ports:
      - "6901:6901"   # noVNC (Web UI)
      - "5901:5901"   # VNC (клиент VNC, если нужно)
      - "8558:8558"    # ZenServer HTTP
    networks:
      - ubuntu_net
```

---

### 🧱 Dockerfile

```dockerfile
FROM accetto/ubuntu-vnc-xfce:latest

LABEL maintainer="AnikBeris@example.com" \
      description="Docker image with XFCE, vcpkg, xmake"

# Основные переменные окружения
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Moscow \
    XMAKE_VERSION=2.9.9 \
    VCPKG_ROOT=/opt/vcpkg \
    PATH="/opt/vcpkg:${PATH}" \
    SHELL=/bin/bash \
    VNC_PW=qwe123 \
    VNC_RESOLUTION=1280x720 \
    VNC_COL_DEPTH=24

# Установка базовых зависимостей и настройка пользователя
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sudo \
        build-essential \
        git \
        curl \
        python3 \
        python3-pip \
        xfce4-terminal \
        && \
    # Создание пользователя developer
    useradd -m -s /bin/bash developer && \
    echo "developer:developer" | chpasswd && \
    usermod -aG sudo developer && \
    # Настройка рабочих директорий
    mkdir -p /home/developer/zen-server && \
    chown -R developer:developer /home/developer && \
    # Настройка оболочки по умолчанию
    ln -sf /bin/bash /bin/sh && \
    echo "SHELL=/bin/bash" >> /etc/environment && \
    # Очистка
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Установка XMake (оптимизированная версия)
RUN set -eux; \
    curl -fsSL https://xmake.io/shget.text | bash || \
    { curl -fsSL "https://github.com/xmake-io/xmake/releases/download/v${XMAKE_VERSION}/xmake-v${XMAKE_VERSION}.linux-x86_64.tar.gz" | \
      tar -xz -C /usr/local --strip-components=1; } || \
    { git clone --depth 1 https://github.com/xmake-io/xmake.git /tmp/xmake && \
      cd /tmp/xmake && ./scripts/get.sh __local__ && \
      cp xmake /usr/local/bin/; }

# Установка vcpkg
RUN git clone https://github.com/microsoft/vcpkg /opt/vcpkg && \
    /opt/vcpkg/bootstrap-vcpkg.sh -disableMetrics && \
    ln -s /opt/vcpkg/vcpkg /usr/local/bin/vcpkg

# Финализация
USER developer
WORKDIR /home/developer/zen-server

# Используем стандартные точки входа базового образа
ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["/bin/bash", "-l"]
```

---

### 📬 Обратная связь

Если у вас возникли проблемы или есть предложения — создайте [Issue](https://github.com/AnikBeris/UE5-zen-server-docker/issues) или Pull Request!
---

---
