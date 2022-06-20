//
//  AlertController.swift
//  GymApp2
//
//  Created by Василий Полторак on 26.04.2022.
//

import UIKit

func alert(with title: String, and message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(alertAction)
    return alert
}


func alertForDiary(completionOne: @escaping () -> Void, completionTwo: @escaping () -> Void) -> UIAlertController {
    let alert = UIAlertController(title: "Имеется не завершенная тренировка", message: "", preferredStyle: .alert)
    let alertAction2 = UIAlertAction(title: "Завершить и сохранить ✅", style: .default) { _ in
        completionTwo()
    }
    let alertAction = UIAlertAction(title: "Не сохранять", style: .default) { _ in
        completionOne()
    }
    alert.addAction(alertAction)
    alert.addAction(alertAction2)
    return alert
}

