//
//  StartViewController.swift
//  GymApp
//
//  Created by mac on 25.04.2022.
//

import UIKit

class StartViewController: UIViewController {
   
    @IBOutlet weak var targetIsEmpty: UIView!
    
    private unowned let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        if userDefaults.array(forKey: "First") == nil {
            userDefaults.setValue(["Грудь", "Трицепс"], forKey: "First")
            userDefaults.setValue(["Бицепс", "Спина"], forKey: "Second")
            userDefaults.setValue(["Ноги"], forKey: "Three")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        targetIsEmpty.isHidden = getCompletedExercise().isEmpty ? true : false
    }
    
    @IBAction func TapButtonDiary(_ sender: Any) {
        if !getCompletedExercise().isEmpty {
            let alert = alertForDiary(completionOne: { self.openDiaryTVC() },
                                      completionTwo: { self.addExerciseToDiary()
                self.openDiaryTVC()})
            
            present(alert, animated: true)
        }
    }
    
    @IBAction func tapAboutUs(_ sender: Any) {
        let names = "Сергей Глущенко: t.me gl_sergeyy \n Василий Полторак: t.me ednzlo"
        let alert = alert(with: "Приложение разработали", and: names)
        present(alert, animated: true)
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        
        let settings = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                       style: .done,
                                       target: self,
                                       action: #selector(openSettings))
        
        navigationItem.setRightBarButtonItems([settings], animated: true)
    }
    
    private func addExerciseToDiary() {
        StorageManager.shared.addValuesForEntity(from: getCompletedExercise())
        StorageManager.shared.saveContext()
        userDefaults.setValue(nil, forKeyPath: "done")
        targetIsEmpty.isHidden = true
    }
    
    private func getCompletedExercise() -> [Exercise] {
        guard let data = userDefaults.value(forKey: "done") as? Data else { return []}
        guard let decoder = try? JSONDecoder().decode([Exercise].self, from: data) else { return []}
        return decoder
    }
    
    @objc private func openSettings() {
        guard let settingsVC = storyboard?.instantiateViewController(withIdentifier: "SettingsVC") else { return }
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    private func openDiaryTVC() {
        guard let diaryTVC = storyboard?.instantiateViewController(withIdentifier: "DiaryTVC") else { return }
        self.navigationController?.pushViewController(diaryTVC, animated: true)
    }
     
}
