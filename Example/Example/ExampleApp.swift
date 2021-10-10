//
//  ExampleApp.swift
//
//  Created by Zack Brown on 18/08/2021.
//

import SwiftUI

@main
struct ExampleApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        
        WindowGroup {
            
            AppView(model: .init()).environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            
            PersistenceController.shared.save()
        }
    }
}
