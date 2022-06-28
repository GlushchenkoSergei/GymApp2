//
//  StorageManager.swift
//  GymApp2
//
//  Created by mac on 17.06.2022.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    // MARK: - Core Data stack
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GymApp2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchData () -> [WorkoutNS] {
        var array: [WorkoutNS] = []
        
        let fetchRequest = WorkoutNS.fetchRequest()
        do {
            array = try context.fetch(fetchRequest)
        } catch let error {
            print("Ошибка в получении данных", error)
        }
        
        return array
    }
    
    func delete(workoutNS: WorkoutNS) {
        context.delete(workoutNS)
    }
    
    func delete(exercisesNS: ExercisesNS) {
        context.delete(exercisesNS)
    }
    
    func addValuesForEntity(from exercisesForSaved: [Exercise], date: Date ) {
        guard let workoutNS = StorageManager.shared.createTypeWorkoutNS() else { return }
        
        let calendar = Calendar.current
        let componentsFromCurrentDate = calendar.dateComponents([.day, .month, .year], from: date)
        guard let date2 = calendar.date(from: componentsFromCurrentDate) else { return }
        
        workoutNS.date = date2
        
        var arrayExercisesNS: [ExercisesNS] = []
        
        for index in 0..<exercisesForSaved.count {
            guard let exercisesNS = StorageManager.shared.createTypeExercisesNS() else { return }
            exercisesNS.descr = exercisesForSaved[index].description
            exercisesNS.image = exercisesForSaved[index].image
            exercisesNS.numberOfRepetitions = exercisesForSaved[index].numberOfRepetitions
            arrayExercisesNS.append(exercisesNS)
        }
        let setExercisesNS = Set(arrayExercisesNS) as? NSSet
        workoutNS.exercises = setExercisesNS
    }
    
    func createTypeWorkoutNS() -> WorkoutNS? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "WorkoutNS", in: context)
        else { return nil}
        
        guard let workoutNS = NSManagedObject(entity: entityDescription,
                                              insertInto: context) as? WorkoutNS
        else { return nil}
        
        return workoutNS
    }
    
    func createTypeExercisesNS() -> ExercisesNS? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "ExercisesNS", in: context)
        else { return nil}
        
        guard let exercisesNS = NSManagedObject(entity: entityDescription,
                                                insertInto: context) as? ExercisesNS
        else { return nil}
        
        return exercisesNS
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
        }
    }
}
