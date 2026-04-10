#!/usr/bin/with-contenv bashio
set -euo pipefail

readonly WORKSPACE_DIR="/homeassistant"
readonly DATA_ROOT="/data"
readonly HOME_DIR="${DATA_ROOT}/home"
readonly CLI_DATA_DIR="${DATA_ROOT}/vscode-cli"
readonly SERVER_DATA_DIR="${DATA_ROOT}/vscode-server"
readonly EXTENSIONS_DIR="${DATA_ROOT}/extensions"

provider="$(bashio::config 'provider')"
tunnel_name="$(bashio::config 'tunnel_name')"
log_level="$(bashio::config 'log_level')"

if ! command -v code >/dev/null 2>&1; then
    bashio::log.fatal "The VS Code CLI is missing from the image."
    exit 1
fi

if [[ ! -d "${WORKSPACE_DIR}" ]]; then
    bashio::log.fatal "Expected the Home Assistant config at ${WORKSPACE_DIR}, but the mount is missing."
    exit 1
fi

if [[ -z "${tunnel_name}" ]]; then
    tunnel_name="ha-${HOSTNAME:-homeassistant}"
fi

mkdir -p \
    "${HOME_DIR}" \
    "${CLI_DATA_DIR}" \
    "${SERVER_DATA_DIR}" \
    "${EXTENSIONS_DIR}"

umask 077

export HOME="${HOME_DIR}"
export VSCODE_CLI_DATA_DIR="${CLI_DATA_DIR}"
export VSCODE_CLI_USE_FILE_KEYCHAIN=1
export VSCODE_CLI_DISABLE_KEYCHAIN_ENCRYPT=1

bashio::log.info "Using workspace: ${WORKSPACE_DIR}"
bashio::log.info "Tunnel name: ${tunnel_name}"
bashio::log.info "Auth provider: ${provider}"

if code tunnel user show >/dev/null 2>&1; then
    bashio::log.info "Existing VS Code tunnel login found in /data."
else
    bashio::log.warning "No VS Code tunnel login found yet."
    bashio::log.warning "The next command prints a sign-in URL and device code into the add-on logs."

    if ! code tunnel user login --provider "${provider}"; then
        bashio::log.fatal "VS Code tunnel login failed."
        exit 1
    fi

    bashio::log.info "VS Code tunnel login completed successfully."
fi

cd "${WORKSPACE_DIR}"

bashio::log.info "Starting VS Code tunnel from ${WORKSPACE_DIR}"

exec code tunnel \
    --name "${tunnel_name}" \
    --accept-server-license-terms \
    --server-data-dir "${SERVER_DATA_DIR}" \
    --extensions-dir "${EXTENSIONS_DIR}" \
    --log "${log_level}"
