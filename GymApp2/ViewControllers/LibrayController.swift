//
//  LibrayController.swift
//  GymApp
//
//  Created by mac on 25.04.2022.
//

import UIKit

class LibraryController: UITableViewController {

    let exercises = DataManage.shared.exercises

    lazy var triceps = getExercises(muscle: .triceps)
    lazy var breast = getExercises(muscle: .breast)
    lazy var back = getExercises(muscle: .back)
    lazy var legs = getExercises(muscle: .legs)
    lazy var biceps = getExercises(muscle: .biceps)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }

    // MARK: - Table view data source
    private func getExercises(muscle: MuscleGroup) -> [Exercise] {
        var selectedExercises = [Exercise]()
            for exercise in exercises {
                if exercise.muscle == muscle {
                    selectedExercises.append(exercise)
                }
            }
        return selectedExercises
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Triceps"
        case 1: return "Breast"
        case 2: return "Back"
        case 3: return "Legs"
        default:
            return "Biceps"
    }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return triceps.count
        case 1: return breast.count
        case 2: return back.count
        case 3: return legs.count
        default:
            return biceps.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return setForContentRows(indexPath: indexPath, triceps: triceps)
        case 1: return setForContentRows(indexPath: indexPath, triceps: breast)
        case 2: return setForContentRows(indexPath: indexPath, triceps: back)
        case 3: return setForContentRows(indexPath: indexPath, triceps: legs)
        default:
            return setForContentRows(indexPath: indexPath, triceps: biceps)
        }
     
    }
    
    
    func setForContentRows(indexPath: IndexPath, triceps: [Exercise] ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "library", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = triceps[indexPath.row].description
        content.secondaryText = triceps[indexPath.row].numberOfRepetitions
        content.image = UIImage(named: triceps[indexPath.row].image)
        cell.contentConfiguration = content
        return cell
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let changeVC = segue.destination as? ChangeDetailController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        var selectedSection: [Exercise] = []
        switch indexPath.section {
        case 0: selectedSection = triceps
        case 1: selectedSection = breast
        case 2: selectedSection = back
        case 3: selectedSection = legs
        default:
            selectedSection =  biceps
        }
        changeVC.exercise = selectedSection[indexPath.row]
    }
}


