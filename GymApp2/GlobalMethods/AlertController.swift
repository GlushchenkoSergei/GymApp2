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


