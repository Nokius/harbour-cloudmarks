/*
    cloud Bookmarks - A SailfishOS client for the ownCloud Bookmarks application.
    Copyright (C) 2015 Hauke Wesselmann
    Contact: Hauke Wesselmann <hauke@h-dawg.de>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "models"
import "utils/SettingsDatabase.js" as SettingsDatabase

ApplicationWindow
{
    id: mainwindow
    allowedOrientations: defaultAllowedOrientations

    initialPage: Component { BookmarksPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    property alias settings: settings

    Settings
    {
        id: settings

        Component.onCompleted: {
            SettingsDatabase.load();
            SettingsDatabase.transaction(function(tx) {
                    var ocUrl = SettingsDatabase.transactionGet(tx, "ocUrl");
                    settings.ocUrl = (ocUrl === false ? "http:\/\/" : ocUrl);

                    var ocUsername = SettingsDatabase.transactionGet(tx, "ocUsername");
                    settings.ocUsername = (ocUsername === false ? "" : ocUsername);

                    var ocPassword = SettingsDatabase.transactionGet(tx, "ocPassword");
                    settings.ocPassword = (ocPassword === false ? "" : ocPassword);
                });
        }
    }

    Rectangle {
        id: infoBanner

        width: parent.width
        height: infoText.height + 2 * Theme.paddingMedium

        color: Theme.highlightBackgroundColor
        opacity: 0.0
        // On top of everything
        z: 1
        visible: opacity > 0.0

        function showText(text) {
            infoText.text = text
            opacity = 0.9
            console.log("INFO: " + text)
            closeTimer.restart()
        }

        Label {
            id: infoText
            anchors.top: parent.top
            anchors.topMargin: Theme.paddingMedium
            x: Theme.paddingMedium
            width: parent.width - 2 * Theme.paddingMedium
            color: Theme.highlightColor
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }

        Behavior on opacity { FadeAnimation {} }

        Timer {
            id: closeTimer
            interval: 3000
            onTriggered: infoBanner.opacity = 0.0
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                closeTimer.stop()
                infoBanner.opacity = 0.0
            }
        }
    }
}


