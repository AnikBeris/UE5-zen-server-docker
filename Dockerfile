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