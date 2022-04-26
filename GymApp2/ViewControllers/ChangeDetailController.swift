//
//  ChangeDetailController.swift
//  GymApp
//
//  Created by mac on 26.04.2022.
//

import UIKit

class ChangeDetailController: UIViewController, UITextFieldDelegate {

    var exercise: Exercise!
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var nameText: UITextField!
    @IBOutlet var descriptionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = UIImage(named: exercise.image)
        nameText.text = exercise.description
        descriptionText.text = exercise.numberOfRepetitions
        image.layer.cornerRadius = image.frame.size.width / 20
        image.clipsToBounds = true
    }
    
    @IBAction func tapSave(_ sender: Any) {
        var counter = 0
        for find in DataManage.shared.exercises {
            if find.description == exercise.description {
                DataManage.shared.exercises[counter].description = nameText.text ?? ""
                DataManage.shared.exercises[counter].numberOfRepetitions = descriptionText.text ?? ""
                showAlert(with: "", and: "Изменения для \(nameText.text ?? "") сохранены!")
            }
            counter += 1
        }
    }
        
    
    @IBAction func tapCancel(_ sender: Any) {
        nameText.text = exercise.description
        descriptionText.text = exercise.numberOfRepetitions
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}



