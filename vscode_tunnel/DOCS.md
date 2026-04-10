# VS Code Tunnel

This add-on starts the official Visual Studio Code CLI and exposes your Home Assistant configuration through a Remote Tunnel. It does not provide a browser IDE, Ingress page, or open ports inside Home Assistant.

## What this add-on does

- Mounts your Home Assistant configuration into the container at `/homeassistant`
- Starts the official `code tunnel` process in that directory
- Persists tunnel login data, server data, extensions, and CLI state in `/data`
- Lets you connect from `vscode.dev` or the VS Code Remote Explorer

## Configuration

```yaml
provider: github
tunnel_name: ""
log_level: info
```

### Option: `provider`

Authentication provider for the initial tunnel login.

- `github`
- `microsoft`

### Option: `tunnel_name`

Optional custom machine name shown in the Remote Explorer.

If left empty, the add-on uses `ha-<hostname>`.

### Option: `log_level`

CLI log level passed to `code tunnel`.

- `info`
- `debug`
- `warn`
- `error`
- `off`

## First start

1. Install the repository and start the add-on.
2. Open the add-on logs in Home Assistant.
3. Wait for the VS Code CLI to print a sign-in URL and device code.
4. Complete the login with the selected provider.
5. Open `vscode.dev` or desktop VS Code.
6. Connect through the Remote Explorer to the tunnel name shown in the logs.

After the first successful login, the credentials stay in `/data` and survive add-on restarts.

## Changing the provider

The selected provider only matters during the first login. If you already authenticated once, changing `provider` in the add-on options does not switch the existing login automatically.

To switch providers, stop the add-on and remove the saved tunnel login data from the add-on data directory, then start it again and complete a fresh login.

## Security notice

This add-on gets write access to your Home Assistant configuration directory. That includes sensitive files such as secrets, credentials, and integration configuration. Only use it if you understand that anyone who can access the tunnel can modify your Home Assistant setup.
