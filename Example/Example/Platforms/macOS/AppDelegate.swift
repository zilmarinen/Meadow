//
//  AppDelegate.swift
//  Meadow
//
//  Created by Zack Brown on 27/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        
        return true
    }
}
