//
//  AppDelegate.swift
//  Mark
//
//  Created by Velislava Yanchina on 10/20/16.
//  Copyright © 2016 Velislava Yanchina. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var defaultWindow:NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        defaultWindow = NSApplication.shared().windows.first
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func openHelp() {
        if let defaultWindow = defaultWindow {
            defaultWindow.makeKeyAndOrderFront(nil)
        }
    }
}

