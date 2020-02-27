//
//  AppDelegate.swift
//  Meadow Example macOS
//
//  Created by Zack Brown on 27/02/2020.
//  Copyright © 2020 3Squared. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        
        return true
    }
}
