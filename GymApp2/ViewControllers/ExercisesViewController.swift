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
    
    // Массивы для сохранения индексов упражнений в дневник
    var indexesDoneExercises = [String: Bool]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValueControl()
        selectExercise()
        
//        updateCompletedExercise()
        
        mainTableView.rowHeight = 80
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailController else { return }
        guard let indexPath = mainTableView.indexPathForSelectedRow else { return }
        detailVC.exercise = selectedExercises[indexPath.row]
        detailVC.delegate = self
        
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        selectExercise()
        mainTableView.reloadData()
    }
    
    func addExerciseToJournal() {
        // здесь нужно реализовать метод сохранения в журнал
        // exercisesForSaved
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
        let selectedSegmentIndex = exerciseGroupsSegmentedControl.selectedSegmentIndex
        let stringIndex = String(selectedSegmentIndex) + "done"
        
        if userDefaults.dictionary(forKey: stringIndex) != nil {
            print("В юзер дефолтс значение")
            indexesDoneExercises = userDefaults.dictionary(forKey: stringIndex) as! [String: Bool]
            print("Востановил значение из юзер дефолтс")
        } else {
            print("не получил значения собираю массив")
            insertBoolValue()
            updateUserData()
        }
        for value in indexesDoneExercises {
            print(value)
        }
    }
    
    private func insertBoolValue() {
        for index in 0..<selectedExercises.count {
            indexesDoneExercises.updateValue(false, forKey: String(index))
        }
        print("массив собрал!!!!!!!!!!!!!!!!!!!!!")
    }
        
       private func updateUserData() {
           
           let selectedSegmentIndex = exerciseGroupsSegmentedControl.selectedSegmentIndex
           let stringIndex = String(selectedSegmentIndex) + "done"
           
           userDefaults.setValue(indexesDoneExercises, forKey: stringIndex)
           print("Загрузил в юзер дефолтс!!!!!!!!!!!!")
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
        
        if indexesDoneExercises[String(indexPath.row)] == true {
            //            cell.layer.insertSublayer(setColorCell(frame: cell.bounds), at: 1)
            cell.backgroundColor = #colorLiteral(red: 0.09485692531, green: 0.1359011829, blue: 1, alpha: 0.3657351867)
            cell.layer.cornerRadius = cell.frame.height / 4
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
        guard let index = self.indexesDoneExercises[String(indexPath.row)] else { return nil}
        let color = index ? #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1) : #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 1)
        let image = index
        ? UIImage(systemName: "multiply.circle.fill")
        : UIImage(systemName: "checkmark.circle.fill")
        
        let actionDone = UIContextualAction(style: .normal, title: "done") { _, _, completion in
            self.indexesDoneExercises[String(indexPath.row)] = index ? false : true
            self.updateUserData()
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
               completion(true)
        }
        
        actionDone.image = image
        actionDone.backgroundColor = color
        
        return UISwipeActionsConfiguration(actions: [actionDone])
    }
    
    
}

//extension ExercisesViewController {
//
//    func setColorCell(frame: CGRect) -> CAGradientLayer {
//        let color1 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0).cgColor
////        let color2 = UIColor(red: 151/255, green: 172/255, blue: 201/255, alpha: 0.5).cgColor
//        let color2 = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 0.1659151797).cgColor
//        let color3 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0).cgColor
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = frame
//        gradientLayer.colors = [color1, color2, color3]
//        return gradientLayer
//    }
//}


