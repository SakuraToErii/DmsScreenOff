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

            width: root.iconSize
            height: root.iconSize
            implicitWidth: width
            implicitHeight: height

            property bool holding: false
            property int remainingSeconds: 0

            Timer {
                id: holdTimer
                interval: 2000
                repeat: false
                onTriggered: {
                    pill.holding = false;
                    pill.remainingSeconds = 0;
                    countdownTimer.stop();
                    root.turnScreenOff();
                }
            }

            Timer {
                id: countdownTimer
                interval: 1000
                repeat: true
                onTriggered: {
                    if (!pill.holding || pill.remainingSeconds <= 1) {
                        stop();
                        return;
                    }
                    pill.remainingSeconds -= 1;
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

            Rectangle {
                width: Math.max(18, root.iconSize * 0.62)
                height: width
                radius: width / 2
                anchors.centerIn: parent
                visible: pill.holding && pill.remainingSeconds > 0
                color: Theme.primary

                StyledText {
                    anchors.centerIn: parent
                    text: pill.remainingSeconds
                    color: Theme.primaryText
                    font.pixelSize: Math.max(12, root.iconSize * 0.42)
                    font.weight: Font.Bold
                }
            }

            MouseArea {
                id: holdMouseArea
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onPressed: {
                    pill.holding = true;
                    pill.remainingSeconds = 2;
                    countdownTimer.restart();
                    holdTimer.restart();
                }

                onReleased: {
                    pill.holding = false;
                    pill.remainingSeconds = 0;
                    countdownTimer.stop();
                    holdTimer.stop();
                }

                onCanceled: {
                    pill.holding = false;
                    pill.remainingSeconds = 0;
                    countdownTimer.stop();
                    holdTimer.stop();
                }

                onExited: {
                    if (holdMouseArea.pressed) {
                        pill.holding = false;
                        pill.remainingSeconds = 0;
                        countdownTimer.stop();
                        holdTimer.stop();
                    }
                }
            }
        }
    }

    horizontalBarPill: longPressPill

    verticalBarPill: longPressPill
}
