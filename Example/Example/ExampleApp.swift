//
//  ExampleApp.swift
//  Shared
//
//  Created by Zack Brown on 18/08/2021.
//

import SwiftUI

@main
struct ExampleApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    var controller = AppController()
    
    var body: some Scene {
        
        WindowGroup {
            
            AppView(controller: controller).environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            
            PersistenceController.shared.save()
        }
    }
}
