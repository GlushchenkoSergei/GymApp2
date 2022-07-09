//
//  StartViewController.swift
//  GymApp
//
//  Created by mac on 25.04.2022.
//

import UIKit

class StartViewController: UIViewController {
   
    @IBOutlet weak var targetIsEmpty: UIView!
    @IBOutlet var buttonDiary: UIButton!
    
    private let userDefaults = UserDefaults.standard
    let diaryList = Array(StorageManager.shared.fetchData().reversed())
    
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
            let alert = alertForDiary(completionOne: { [weak self] in self?.openDiaryVC() },
                                      completionTwo: { [weak self] in self?.addExerciseToDiary()
                self?.openDiaryVC()})
            
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
        let date = Date()
        StorageManager.shared.addValuesForEntity(from: getCompletedExercise(), date: date)
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
    
    private func openDiaryVC() {
        guard let diaryVC = storyboard?.instantiateViewController(withIdentifier: "DiaryVC") else { return }
        self.navigationController?.pushViewController(diaryVC, animated: true)
    }
     
}
