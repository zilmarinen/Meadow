//
//  ExampleApp.swift
//  Shared
//
//  Created by Zack Brown on 18/08/2021.
//

import SwiftUI

@main
struct ExampleApp: App {
    
    @ObservedObject var controller = Controller()
    
    var body: some Scene {
        
        WindowGroup {
            
            ContentView(controller: controller)
        }
    }
}
