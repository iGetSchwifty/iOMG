//
//  PersistentContainer.swift
//  iOMG
//
//  Created by Tacenda on 5/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import CoreData

class PersistentContainer {
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iOMG")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    static let viewContext = persistentContainer.viewContext

    static func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }
    
    static func clear() {
        viewContext.perform {
            persistentContainer.managedObjectModel.entities.forEach {

                guard let name = $0.name else { return }

                let fetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: name)
                let request = NSBatchDeleteRequest(fetchRequest: fetch)
                request.resultType = .resultTypeObjectIDs

                do {
                    guard let req = try persistentContainer.persistentStoreCoordinator.execute(request, with: viewContext) as? NSBatchDeleteResult else { return }

                    NSManagedObjectContext.mergeChanges(
                        fromRemoteContextSave: [NSDeletedObjectsKey: req.result as? [NSManagedObjectID] ?? []],
                        into: [viewContext])
                }
                catch let e {
                    print(e)
                }
            }
        }
    }
}
