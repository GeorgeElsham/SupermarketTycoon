//
//  Persistence.swift
//  SupermarketTycoon
//
//  Created by George Elsham on 03/12/2020.
//

import CoreData


struct PersistenceController {
    
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.container.viewContext
        
        do {
            try viewContext.save()
        } catch {
            fatalError("Unresolved error: '\(error.localizedDescription)'.")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "SupermarketTycoon")
        
        container.loadPersistentStores { _, error in
            guard let error = error else { return }
            fatalError("Core Data error: '\(error.localizedDescription)'.")
        }
    }
}
