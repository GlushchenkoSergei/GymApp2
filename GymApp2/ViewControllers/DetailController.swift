//
//  DelailController.swift
//  GymApp
//
//  Created by mac on 24.04.2022.
//

import UIKit

class DetailController: UIViewController {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    
    private let userDefaults = UserDefaults.standard
    
    var exercise: Exercise!
    var exercisesForSaved: [Exercise]!
    weak var delegate: ExercisesControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = UIImage(named: exercise.image)
        nameLabel.text = exercise.description
        image.clipsToBounds = true
        doneButton.backgroundColor = setColorButton()
    }
    
    @IBAction func buttonTimerTapped(_ sender: Any) {
        present(TimerViewController(), animated: true)
    }
    
    @IBAction func tapDoneButton(_ sender: UIButton) {
        checkSavedExercises()
        doneButton.backgroundColor = setColorButton()
        delegate?.saveExercise(exercises: exercisesForSaved)
        updateUserData()
        self.dismiss(animated: true)
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func checkSavedExercises() {
        if !exercisesForSaved.contains(exercise) {
            exercisesForSaved.append(exercise)
        } else {
            guard let index = exercisesForSaved.firstIndex(of: exercise) else { return }
            exercisesForSaved.remove(at: index)
        }
    }
    
    private func setColorButton() -> UIColor {
        exercisesForSaved.contains(exercise) ? #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 1) : .darkGray
    }
    
    private func updateUserData() {
        guard let encodeData = try? JSONEncoder().encode(exercisesForSaved) else { return }
        userDefaults.setValue(encodeData, forKeyPath: "done")
    }
    
}
