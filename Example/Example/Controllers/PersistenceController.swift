//
//  PersistenceController.swift
//
//  Created by Zack Brown on 19/08/2021.
//

import Foundation
import CoreData

struct PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        
        container = NSPersistentContainer(name: "Example")

        if inMemory {
            
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            
            if let error = error {
                
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        
        let context = container.viewContext
        
        guard context.hasChanges else { return }

        do {
            try context.save()
            
        } catch {
            
            print("CoreData error saving context: \(error)")
        }
    }
}
