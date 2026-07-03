import QtQuick
import Quickshell.Io
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    function turnScreenOff() {
        if (dpmsOffProcess.running) {
            dpmsOffProcess.running = false;
        }
        dpmsOffProcess.running = true;
    }

    Process {
        id: dpmsOffProcess
        command: ["dms", "dpms", "off"]
        running: false
    }

    ccWidgetIcon: "desktop_access_disabled"
    ccWidgetPrimaryText: "Screen Off"
    ccWidgetSecondaryText: "Display power"
    ccWidgetIsToggle: false
    ccDetailHeight: 96

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

    ccDetailContent: Component {
        Rectangle {
            id: detailRoot
            implicitHeight: 88
            radius: Theme.cornerRadius
            color: Theme.surfaceContainerHigh
            border.width: 0

            property bool holding: false

            Timer {
                id: detailHoldTimer
                interval: 2000
                repeat: false
                onTriggered: {
                    detailRoot.holding = false;
                    root.turnScreenOff();
                }
            }

            Rectangle {
                id: holdButton
                anchors.fill: parent
                anchors.margins: Theme.spacingM
                radius: Theme.cornerRadius
                color: detailRoot.holding ? Theme.primary : Theme.surfaceContainer
                border.color: detailRoot.holding ? Theme.primary : Theme.outlineMedium
                border.width: Theme.layerOutlineWidth

                Row {
                    anchors.centerIn: parent
                    spacing: Theme.spacingM

                    DankIcon {
                        name: "desktop_access_disabled"
                        size: Theme.iconSize
                        color: detailRoot.holding ? Theme.primaryText : Theme.surfaceText
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    StyledText {
                        text: "Screen Off"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.Medium
                        color: detailRoot.holding ? Theme.primaryText : Theme.surfaceText
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: detailHoldMouseArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onPressed: {
                        detailRoot.holding = true;
                        detailHoldTimer.restart();
                    }

                    onReleased: {
                        detailRoot.holding = false;
                        detailHoldTimer.stop();
                    }

                    onCanceled: {
                        detailRoot.holding = false;
                        detailHoldTimer.stop();
                    }

                    onExited: {
                        if (detailHoldMouseArea.pressed) {
                            detailRoot.holding = false;
                            detailHoldTimer.stop();
                        }
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
