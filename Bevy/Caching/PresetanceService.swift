//
//  PresetanceService.swift
//  Bevy
//
//  Created by KarimAhmed on 24/10/2021.
//

import Foundation
import CoreData


class PresesistancService {
    
    private init() {}
    static let shared = PresesistancService()
    var context: NSManagedObjectContext{return persistentContainer.viewContext}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Bevy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        //bg
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                NotificationCenter.default.post(name: NSNotification.Name("persistantUpdated"), object: nil)
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type, completion: @escaping ([T]) -> Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do{
            let objects = try context.fetch(request)
            completion(objects)
        }catch{
            print(error)
            completion([])
        }
    }
}
