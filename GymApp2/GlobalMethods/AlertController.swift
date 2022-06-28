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
    let alert = UIAlertController(title: "Имеется не завершенная тренировка", message: "", preferredStyle: .actionSheet)
    let alertAction2 = UIAlertAction(title: "Завершить и сохранить ", style: .cancel) { _ in
        completionTwo()
    }
    let alertAction = UIAlertAction(title: "Не сохранять", style: .default) { _ in
        completionOne()
    }
    alert.addAction(alertAction)
    alert.addAction(alertAction2)
    return alert
}

func alertWithCompletions(preferredStyle: UIAlertController.Style, title: String, actionOneTitle: String, actionTwoTitle: String, completionOne: @escaping () -> Void, completionTwo: @escaping () -> Void) -> UIAlertController {
    let alert = UIAlertController(title: title, message: "", preferredStyle: preferredStyle)
    let alertAction = UIAlertAction(title: actionOneTitle, style: .cancel) { _ in
        completionOne()
    }
    let alertAction2 = UIAlertAction(title: actionTwoTitle, style: .destructive) { _ in
        completionTwo()
    }
    alert.addAction(alertAction)
    alert.addAction(alertAction2)
    return alert
}


