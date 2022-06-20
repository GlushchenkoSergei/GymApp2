//
//  DiaryTableViewController.swift
//  GymApp2
//
//  Created by mac on 18.06.2022.
//

import UIKit

class DiaryTableViewController: UITableViewController {
    
//данные кор дата
    private let diaryList = Array(StorageManager.shared.fetchData().reversed())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRightButtonItem()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let diaryDetailVC = segue.destination as? DiaryDetailTableViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        guard let exercisesNS = diaryList[indexPath.row].exercises?.allObjects as? [ExercisesNS] else { return }
        diaryDetailVC.exercisesNS = exercisesNS
    }
    

    private func setRightButtonItem() {
        let save = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(saveAction))
       navigationItem.setRightBarButtonItems([save], animated: true)
    }
    
    @objc private func saveAction() {
       // Изменение даты и удаление записи тренеровки
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        diaryList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let workout = diaryList[indexPath.row]
        content.text = "\(workout.date ?? Date())"
        content.secondaryText = "Заходи"
        content.textProperties.color = .red
        cell.backgroundColor = .yellow
        cell.contentConfiguration = content
        return cell
    }
    
}
