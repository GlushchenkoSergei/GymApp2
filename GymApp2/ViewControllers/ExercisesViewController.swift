//
//  ExercisesViewController.swift
//  GymApp
//
//  Created by mac on 23.04.2022.
//

import UIKit
import CoreData

protocol ExercisesControllerProtocol {
    func saveExercise(exercises: [Exercise])
}

class ExercisesViewController: UIViewController {
    
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet weak var exerciseGroupsSegmentedControl: UISegmentedControl!
    
    private let userDefaults = UserDefaults.standard
    
    
    private let exercises = DataManage.shared.exercises
    private var selectedExercises = [Exercise]()
    private var exercisesForSaved = [Exercise]()
    
    let itemTimer = UINavigationItem(title: "Таймер")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValueControl()
        selectExercise()
        mainTableView.rowHeight = 80
        mainTableView.separatorColor = .black
        
        exerciseGroupsSegmentedControl.setTitleTextAttributes(
            [.foregroundColor: UIColor.white], for: .normal
        )
        setRightButtonItem()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailController else { return }
        guard let indexPath = mainTableView.indexPathForSelectedRow else { return }
        detailVC.exercise = selectedExercises[indexPath.row]
        detailVC.exercisesForSaved = exercisesForSaved
        detailVC.delegate = self
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        selectExercise()
        mainTableView.reloadData()
    }
    
    private func setRightButtonItem() {
        let save = UIBarButtonItem(barButtonSystemItem: .save,
                                   target: self,
                                   action: #selector(addExerciseToJournal))
       navigationItem.setRightBarButtonItems([save], animated: true)
    }
    
    
    
    @objc private func addExerciseToJournal() {
        addValuesForEntity()
        StorageManager.shared.saveContext()
        
        let alert = UIAlertController(title: "Тренеровка сохранена", message: "", preferredStyle: .alert)
        present(alert, animated: true)
        dismiss(animated: true)
    }
    
    private func addValuesForEntity() {
        var arrayExercisesNS: [ExercisesNS] = []
        
        guard let workoutNS = StorageManager.shared.createTypeWorkoutNS() else { return }

        for index in 0..<exercisesForSaved.count {
            guard let exercisesNS = StorageManager.shared.createTypeExercisesNS() else { return }
            exercisesNS.descr = exercisesForSaved[index].description
            exercisesNS.image = exercisesForSaved[index].image
            exercisesNS.numberOfRepetitions = exercisesForSaved[index].numberOfRepetitions
            arrayExercisesNS.append(exercisesNS)
    }
        let setExercisesNS = Set(arrayExercisesNS) as? NSSet
        
        workoutNS.date = Date()
        workoutNS.exercises = setExercisesNS
    }
    
    
    private func setValueControl() {
        guard userDefaults.array(forKey: "numberSegment") != nil else { return }
        let values = userDefaults.array(forKey: "numberSegment") as! [Int]
        let value = values[0]
        
        exerciseGroupsSegmentedControl.removeSegment(at: 2, animated: false)
        exerciseGroupsSegmentedControl.removeSegment(at: 1, animated: false)
        
        switch value {
        case 1:
            return
        case 2:
            addSegment("Second")
        default:
            addSegment("Second")
            addSegment("Three")
        }
    }
    
    private func addSegment(_ name: String) {
       let number = exerciseGroupsSegmentedControl.numberOfSegments
        exerciseGroupsSegmentedControl.insertSegment(withTitle: name, at: number, animated: false)
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
        updateCompletedExercise()
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
    
    private func updateCompletedExercise() {
        guard let data = userDefaults.value(forKey: "done") as? Data else { return }
        guard let decoder = try? JSONDecoder().decode([Exercise].self, from: data) else { return }
        exercisesForSaved = decoder
    }

       private func updateUserData() {
           guard let encodeData = try? JSONEncoder().encode(exercisesForSaved) else { return }
           userDefaults.setValue(encodeData, forKeyPath: "done")
    }
    
}

// MARK: - Настройка делегирования
extension ExercisesViewController: ExercisesControllerProtocol {
    func saveExercise(exercises: [Exercise]) {
        exercisesForSaved = exercises
        mainTableView.reloadData()
    }
}

// MARK: - Настройка табличного представления
extension ExercisesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showExercises", for: indexPath)
        
        let exercise = selectedExercises[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.textProperties.color = #colorLiteral(red: 0, green: 0.798466444, blue: 0.9789896607, alpha: 0.7078630743)
        content.secondaryTextProperties.color = .white
        content.text = exercise.description
        content.secondaryText = exercise.numberOfRepetitions
        content.image = UIImage(named: exercise.image)
        content.imageProperties.maximumSize = CGSize(width: 70, height: 70)
        cell.contentConfiguration = content
        
        if exercisesForSaved.contains(exercise) {
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 0.38)
            cell.layer.cornerRadius = cell.frame.height / 10
        } else {
            cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - swipe action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let index = exercisesForSaved.contains(selectedExercises[indexPath.row])
        let exercise = selectedExercises[indexPath.row]
        
        let color = index ? #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1) : #colorLiteral(red: 0, green: 0.798466444, blue: 0.9789896607, alpha: 0.4459887048)
        let imageName = index ? "multiply.circle.fill": "checkmark.circle.fill"
        
        let actionDone = UIContextualAction(style: .normal, title: "done") { _, _, completion in
            
            if !self.exercisesForSaved.contains(exercise) {
                self.exercisesForSaved.append(exercise)
            } else {
                guard let index = self.exercisesForSaved.firstIndex(of: exercise) else { return }
                self.exercisesForSaved.remove(at: index)
            }
            self.updateUserData()
            tableView.reloadRows(at: [indexPath], with: .automatic)
               completion(true)
        }
        
        actionDone.image = UIImage(systemName: imageName)
        actionDone.backgroundColor = color
        
        return UISwipeActionsConfiguration(actions: [actionDone])
    }
    
}


