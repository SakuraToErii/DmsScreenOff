# DMS Screen Off

Screen Off is a tiny DankBar widget for [DankMaterialShell](https://danklinux.com/) that turns off all monitors.

Inspired by the missing "turn off screen" affordance in the default power controls.

## Features

- DankBar widget with a display-off icon
- Control Center widget with expandable long-press action
- Long press for 2 seconds to turn off monitors
- Optional compositor shortcut, disabled by default
- Uses DMS display power management through `dms dpms off`
- Works with the DMS keybind system for supported compositors

## Installation

### Using DMS CLI

```sh
dms plugins install screenOff
```

### Using DMS Settings

1. Open Settings -> Plugins
2. Click "Browse"
3. Enable third party plugins
4. Install and enable Screen Off
5. Add "Screen Off" to your DankBar widgets list

### Manual

1. Clone this repository into your DMS plugins directory:

```sh
git clone https://github.com/SakuraToErii/DmsScreenOff ~/.config/DankMaterialShell/plugins/screenOff
```

2. Open Settings -> Plugins and click "Scan"
3. Enable "Screen Off"
4. Add "Screen Off" to your DankBar widgets list

## Requirements

- DankMaterialShell 1.2.0 or newer
- `dms` CLI available in `PATH`
- A compositor/display backend supported by `dms dpms off`

## Configuration

Settings available in plugin settings:

- **Provider**: DMS keybind provider used for optional shortcut management (default: `niri`)
- **Shortcut**: Optional DMS keybind. Default is empty, so no plugin-managed shortcut is created.

When a shortcut is configured, the plugin writes a DMS keybind with this action:

```sh
spawn dms dpms off
```

Clearing the shortcut removes the last keybind managed by this plugin.

## Usage

Bar widget shows:

- A `desktop_access_disabled` Material Symbols icon

Long press the widget for 2 seconds to turn off all monitors. Press any key or move the mouse to wake the display again.

## About

Screen Off plugin for DankMaterialShell.

### License

MIT
