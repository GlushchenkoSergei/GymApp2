//
//  AlertController.swift
//  GymApp2
//
//  Created by Василий Полторак on 26.04.2022.
//

import UIKit

enum Alert {
    // тест для комита
   static func alert(with title: String, and message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        return alert
    }
    
   static func alertWithCompletions(style preferredStyle: UIAlertController.Style, title: String, actionTitleOne: String, actionTitleTwo: String, completionOne: @escaping () -> Void, completionTwo: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: "", preferredStyle: preferredStyle)
        let alertAction = UIAlertAction(title: actionTitleOne, style: .cancel) { _ in
            completionOne()
        }
        let alertAction2 = UIAlertAction(title: actionTitleTwo, style: .destructive) { _ in
            completionTwo()
        }
        alert.addAction(alertAction)
        alert.addAction(alertAction2)
        return alert
    }
}

