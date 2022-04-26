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
    
    
    //Функционал надо вынести в отдельный метод название которого будет говорить что происходит в этом методе
    //Кроме того нужен делегат из библиотеки чтобы менял информацию после скрытия экрана
    //Ну и пожалуй экран можно уменьшить, потому что на SE клавиатура скрывает все
    @IBAction func tapSave(_ sender: Any) {
        var counter = 0
        for exercises in DataManage.shared.exercises {
            if exercises.description == exercise.description {
                DataManage.shared.exercises[counter].description = nameText.text ?? ""
                DataManage.shared.exercises[counter].numberOfRepetitions = descriptionText.text ?? ""
                let alert = alert(with: "", and: "Изменения для \(nameText.text ?? "") сохранены!")
                present(alert, animated: true)
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

}



