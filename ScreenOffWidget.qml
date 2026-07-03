import QtQuick
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    function turnScreenOff() {
        console.info("ScreenOff: power off monitors requested");
        CompositorService.powerOffMonitors();
    }

    ccWidgetIcon: "desktop_access_disabled"
    ccWidgetPrimaryText: "Screen Off"
    ccWidgetSecondaryText: "Off"
    ccWidgetIsToggle: false

    onCcWidgetToggled: root.turnScreenOff()

    Component {
        id: longPressPill

        Item {
            id: pill

            implicitWidth: root.iconSize
            implicitHeight: root.iconSize

            property bool holding: false

            Timer {
                id: holdTimer
                interval: 2000
                repeat: false
                onTriggered: {
                    pill.holding = false;
                    root.turnScreenOff();
                }
            }

            DankIcon {
                anchors.fill: parent
                name: "desktop_access_disabled"
                color: Theme.primary
                size: root.iconSize
                filled: pill.holding
                opacity: pill.holding ? 0.7 : 1.0
            }

            MouseArea {
                id: holdMouseArea
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onPressed: {
                    pill.holding = true;
                    holdTimer.restart();
                }

                onReleased: {
                    pill.holding = false;
                    holdTimer.stop();
                }

                onCanceled: {
                    pill.holding = false;
                    holdTimer.stop();
                }

                onExited: {
                    if (holdMouseArea.pressed) {
                        pill.holding = false;
                        holdTimer.stop();
                    }
                }
            }
        }
    }

    horizontalBarPill: Component {
        Loader {
            sourceComponent: longPressPill
        }
    }

    verticalBarPill: Component {
        Loader {
            sourceComponent: longPressPill
        }
    }
}
