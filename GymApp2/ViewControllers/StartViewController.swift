//
//  StartViewController.swift
//  GymApp
//
//  Created by mac on 25.04.2022.
//

import UIKit

class StartViewController: UIViewController {
   
    private let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefaults.array(forKey: "First") == nil {
            userDefaults.setValue(["Грудь", "Трицепс"], forKey: "First")
            userDefaults.setValue(["Бицепс", "Спина"], forKey: "Second")
            userDefaults.setValue(["Ноги"], forKey: "Three")
        }
    }
   
    @IBAction func buttonDiary(_ sender: Any) {
        let alert = alert(with: "In next update", and: "Скоро релиз ф-ци дневника")
        present(alert, animated: true)
        
    }
    
    @IBAction func tapAboutUs(_ sender: Any) {
        let names = "Сергей Глущенко: t.me gl_sergeyy \n Василий Полторак: t.me ednzlo"
        let alert = alert(with: "Приложение разработали", and: names)
        present(alert, animated: true)
    }
    
}
