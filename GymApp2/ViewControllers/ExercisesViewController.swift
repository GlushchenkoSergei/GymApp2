//
//  ExercisesViewController.swift
//  GymApp
//
//  Created by mac on 23.04.2022.
//

import UIKit

protocol ExercisesControllerProtocol {
    func saveExercise(exercise: Exercise)
}

class ExercisesViewController: UIViewController{
    
    @IBOutlet var mainTableView: UITableView!
    
    @IBOutlet weak var exerciseGroupsSegmentedControl: UISegmentedControl!
    
    private let userDefaults = UserDefaults.standard
    
    private let exercises = DataManage.shared.exercises
    private var selectedExercises = [Exercise]()
    private var exercisesForSaved = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValueControl()
        selectExercise()
        mainTableView.rowHeight = 80
        
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        selectExercise()
        mainTableView.reloadData()
    }
    
    private func setValueControl() {
        guard userDefaults.array(forKey: "numberSegment") != nil else { return }
        let values = userDefaults.array(forKey: "numberSegment") as! [Int]
        let value = values[0]
        
        exerciseGroupsSegmentedControl.removeSegment(at: 2, animated: false)
        exerciseGroupsSegmentedControl.removeSegment(at: 1, animated: false)
        
        switch value {
        case 1: return
        case 2: addSecond()
        default: addSecond()
                addThree()
        }
    }
    
//    private func addFirst() {
//        exerciseGroupsSegmentedControl.insertSegment(withTitle: "First", at: 0, animated: false)
//    }
    private func addSecond() {
        exerciseGroupsSegmentedControl.insertSegment(withTitle: "Second", at: 1, animated: false)
    }
    private func addThree() {
        exerciseGroupsSegmentedControl.insertSegment(withTitle: "Three", at: 2, animated: false)
    }
    
    private func selectExercise() {
        let selectedSegmentIndex = exerciseGroupsSegmentedControl.selectedSegmentIndex
        guard let titleSegment = exerciseGroupsSegmentedControl.titleForSegment(at: selectedSegmentIndex) else { return }
        
        let muscleGroupStrings = userDefaults.array(forKey: titleSegment) as! [String]
        
        var muscleGroup = [MuscleGroup]()
        for muscle in muscleGroupStrings {
            muscleGroup.append(MuscleGroup(rawValue: muscle)!)
        }
        
        changeExercise(muscles: muscleGroup)
    }
    
    private func changeExercise(muscles: [MuscleGroup])  {
        selectedExercises.removeAll()
        
        for muscle in muscles {
            for exercise in exercises {
                if exercise.muscle == muscle {
                    selectedExercises.append(exercise)
                }
            }
        }
    }
    
    func addExerciseToJournal() {
        // здесь надо реализовать метод сохранения в журнал
        // exercisesForSaved
    }
    
// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailController else { return }
        guard let indexPath = mainTableView.indexPathForSelectedRow else { return }
        detailVC.exercise = selectedExercises[indexPath.row]
        detailVC.delegate = self
    }
}

// MARK: - Настройка делегирования
extension ExercisesViewController: ExercisesControllerProtocol {
    
    func saveExercise(exercise: Exercise) {
        exercisesForSaved.append(exercise)
    }
}

// MARK: - Настройка табличного представления
extension ExercisesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showExercises", for: indexPath)
        
        let exercises = selectedExercises[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.color = UIColor(red: 0/255, green: 169/255, blue: 209/255, alpha: 1)
        content.secondaryTextProperties.color = .gray
        content.text = exercises.description
        content.secondaryText = exercises.numberOfRepetitions
        content.image = UIImage(named: exercises.image)
        content.imageProperties.maximumSize = CGSize(width: 70, height: 70)
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


