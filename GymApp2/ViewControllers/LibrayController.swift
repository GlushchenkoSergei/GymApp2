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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Triceps"
        case 1: return "Breast"
        case 2: return "Back"
        case 3: return "Legs"
        default: return "Biceps"
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
        default: return biceps.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return setForContentRows(indexPath: indexPath, muscle: triceps)
        case 1: return setForContentRows(indexPath: indexPath, muscle: breast)
        case 2: return setForContentRows(indexPath: indexPath, muscle: back)
        case 3: return setForContentRows(indexPath: indexPath, muscle: legs)
        default: return setForContentRows(indexPath: indexPath, muscle: biceps)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let changeVC = segue.destination as? ChangeDetailController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let selectedSection = selectedSection(indexPath)
        changeVC.exercise = selectedSection[indexPath.row]
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
    
    
    private func selectedSection(_ at: IndexPath) -> [Exercise] {
        switch at.section {
        case 0: return triceps
        case 1: return breast
        case 2: return back
        case 3: return legs
        default: return biceps
        }
    }
    
    private func setForContentRows(indexPath: IndexPath, muscle: [Exercise] ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "library", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = muscle[indexPath.row].description
        content.secondaryText = muscle[indexPath.row].numberOfRepetitions
        content.image = UIImage(named: muscle[indexPath.row].image)
        cell.contentConfiguration = content
        return cell
    }
}


