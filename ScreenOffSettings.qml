import QtQuick
import Quickshell.Io
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "screenOff"

    property string pendingShortcut: ""
    property string pendingAfterRemoveShortcut: ""
    property string statusText: ""

    function syncShortcutBind() {
        if (!pluginService) {
            return;
        }

        const provider = String(loadValue("provider", "niri") || "").trim();
        const nextShortcut = String(loadValue("shortcut", "") || "").trim();
        const previousShortcut = String(loadState("appliedShortcut", "") || "").trim();

        if (!provider) {
            statusText = "Set a provider before applying a shortcut.";
            return;
        }

        if (nextShortcut === previousShortcut) {
            statusText = nextShortcut ? ("Shortcut active: " + nextShortcut) : "No shortcut configured.";
            return;
        }

        if (previousShortcut) {
            pendingAfterRemoveShortcut = nextShortcut;
            pendingShortcut = previousShortcut;
            removeShortcutProcess.command = ["dms", "keybinds", "remove", provider, previousShortcut];
            removeShortcutProcess.running = true;
            statusText = "Removing previous shortcut: " + previousShortcut;
            return;
        }

        if (nextShortcut) {
            runSetShortcut(provider, nextShortcut);
            return;
        }

        statusText = "No shortcut configured.";
    }

    function runSetShortcut(provider, shortcut) {
        pendingShortcut = shortcut;
        setShortcutProcess.command = [
            "dms",
            "keybinds",
            "set",
            provider,
            shortcut,
            "spawn dms dpms off",
            "--desc",
            "Screen Off"
        ];
        setShortcutProcess.running = true;
        statusText = "Applying shortcut: " + shortcut;
    }

    Component.onCompleted: Qt.callLater(syncShortcutBind)
    onPluginServiceChanged: Qt.callLater(syncShortcutBind)
    onSettingChanged: Qt.callLater(syncShortcutBind)

    Process {
        id: removeShortcutProcess
        running: false
        onExited: (exitCode, exitStatus) => {
            root.saveState("appliedShortcut", "");

            const nextShortcut = root.pendingAfterRemoveShortcut;
            root.pendingAfterRemoveShortcut = "";
            root.pendingShortcut = "";

            if (nextShortcut) {
                const provider = String(root.loadValue("provider", "niri") || "").trim();
                if (provider) {
                    root.runSetShortcut(provider, nextShortcut);
                } else {
                    root.statusText = "Set a provider before applying a shortcut.";
                }
                return;
            }

            root.statusText = exitCode === 0 ? "Shortcut removed." : "Shortcut cleared from plugin state.";
        }
    }

    Process {
        id: setShortcutProcess
        running: false
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.saveState("appliedShortcut", root.pendingShortcut);
                root.statusText = "Shortcut active: " + root.pendingShortcut;
            } else {
                root.statusText = "Failed to apply shortcut: " + root.pendingShortcut;
            }
            root.pendingShortcut = "";
        }
    }

    StyledText {
        width: parent.width
        text: "Screen Off Settings"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: "Configure the optional compositor shortcut used to turn off all monitors."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StringSetting {
        settingKey: "provider"
        label: "Provider"
        description: "DMS keybind provider. Common values: niri, hyprland, sway."
        defaultValue: "niri"
        placeholder: "niri"
    }

    StringSetting {
        settingKey: "shortcut"
        label: "Shortcut"
        description: "Leave empty for no plugin-managed shortcut. Example: Mod+Shift+P"
        defaultValue: ""
        placeholder: "Mod+Shift+P"
    }

    StyledText {
        width: parent.width
        text: root.statusText
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }
}
