//
//  FirlsController.swift
//  GymApp
//
//  Created by mac on 25.04.2022.
//

import UIKit

class FirlsController: UIViewController {
   
    private let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefaults.array(forKey: "First") == nil {
            userDefaults.setValue(["Спина", "Бицепс"], forKey: "First")
            userDefaults.setValue(["Ноги"], forKey: "Second")
            userDefaults.setValue(["Грудь", "Трицепс"], forKey: "Three")
        }
    }
   
    @IBAction func buttonDiary(_ sender: Any) {
        showAlert(with: "In next update", and: "Скоро релиз ф-ци дневника")
    }
    
    @IBAction func tapAboutUs(_ sender: Any) {
        showAlert(with: "Приложение разработали", and: """
Сергей Глущенко: t.me gl_sergeyy
Василий Полторак: t.me ednzlo
"""
        )
    }
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
