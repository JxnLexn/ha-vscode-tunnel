ARG BUILD_ARCH
FROM ghcr.io/home-assistant/base:latest

ARG BUILD_ARCH

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    git \
    libgcc \
    libstdc++ \
    nodejs \
    npm \
    py3-pip \
    python3 \
    ripgrep \
    tar

RUN case "${BUILD_ARCH}" in \
        amd64) cli_arch="x64" ;; \
        aarch64) cli_arch="arm64" ;; \
        armv7|armhf) cli_arch="armhf" ;; \
        "") \
            case "$(apk --print-arch)" in \
                x86_64) cli_arch="x64" ;; \
                aarch64) cli_arch="arm64" ;; \
                armv7|armhf) cli_arch="armhf" ;; \
                *) echo "Unsupported Alpine architecture: $(apk --print-arch)" >&2; exit 1 ;; \
            esac ;; \
        *) echo "Unsupported Home Assistant architecture: ${BUILD_ARCH}" >&2; exit 1 ;; \
    esac \
    && curl -LfsS "https://update.code.visualstudio.com/latest/cli-linux-${cli_arch}/stable" -o /tmp/vscode_cli.tar.gz \
    && tar -xf /tmp/vscode_cli.tar.gz -C /usr/local/bin \
    && rm -f /tmp/vscode_cli.tar.gz \
    && chmod +x /usr/local/bin/code

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
