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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    //После скрытия экрана информация сохраняется Т.К. DataManage - синглТон
    //Но только до момента закрытия приложения - так просто заготовка (после тем с данными обновить можно)
    //Просто не придумал как лучше это реализовать: всю базу без защиты тоже плохо вроде как без защиты
    
    //Отступы и положнения контента на экране сдвинул стало получше. Но не идеал конечно
    
    @IBAction func tapSave(_ sender: Any) {
        changeDataExercise()
    }

    @IBAction func tapCancel(_ sender: Any) {
        nameText.text = exercise.description
        descriptionText.text = exercise.numberOfRepetitions
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    private func changeDataExercise() {
        var counter = 0
        for exercises in DataManage.shared.exercises {
            if exercises.description == exercise.description {
                DataManage.shared.exercises[counter].description = nameText.text ?? ""
                DataManage.shared.exercises[counter].numberOfRepetitions = descriptionText.text ?? ""
                let alert = Alert.shared.alert(with: "", and: "Изменения для \(nameText.text ?? "") сохранены!")
                present(alert, animated: true)
            }
            counter += 1
        }
    }
    
}



