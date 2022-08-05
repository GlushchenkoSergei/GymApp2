//
//  DiaryViewController.swift
//  GymApp2
//
//  Created by mac on 20.06.2022.
//

import UIKit

class DiaryViewController: UIViewController {
    
    @IBOutlet var mainCollectionView: UICollectionView!
    @IBOutlet var mainTableView: UITableView!
    
    private var editingStyleCustom = false
    
    private var oldAndNewSelectedIndex: [IndexPath] = []
    
    private var indexSelected = 0 {
        willSet {
            oldAndNewSelectedIndex.removeAll()
            oldAndNewSelectedIndex.append(createIndexPath(newValue))
        }
        didSet {
            mainTableView.reloadData()
            oldAndNewSelectedIndex.append(createIndexPath(oldValue))
            
            if !editingStyleCustom {
                mainCollectionView.reloadItems(at: oldAndNewSelectedIndex)
            }
        }
    }
    
    private var diaryList = Array(StorageManager.shared.fetchData().reversed())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Дневник"
        mainTableView.rowHeight = 60
        setRightButtonItem()
    }
    
    private func createIndexPath(_ value: Int) -> IndexPath {
        IndexPath(row: value, section: 0)
    }
    
    private func setRightButtonItem() {
        let edit = UIBarButtonItem(title: editingStyleCustom ? "Done" : "Edit",
                                   style: .done,
                                   target: self,
                                   action: #selector(editAction))
        navigationItem.setRightBarButtonItems([edit], animated: true)
    }
    
    @objc private func editAction() {
        mainTableView.isEditing = editingStyleCustom ? false : true
        mainCollectionView.isEditing = editingStyleCustom ? false : true
        editingStyleCustom.toggle()
        
        setRightButtonItem()
        mainCollectionView.reloadItems(at: [createIndexPath(indexSelected)])
    }
    
}
//MARK: - Set Collection View
extension DiaryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateViewCell
        cell.labelDate.textColor = .white
        cell.backgroundColor = indexPath.row == indexSelected ? #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 0.783088197) : #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 0.2095088004)
        cell.labelDate.text = diaryList[indexPath.row].date?.formatted(
            Date.FormatStyle()
                .day()
                .month()
                .year()
        )
        
        cell.layer.cornerRadius = cell.frame.height / 4
        cell.labelDelete.isHidden = true
        
        if indexSelected == indexPath.row {
            cell.labelDelete.isHidden = !editingStyleCustom
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if editingStyleCustom, indexPath.row == indexSelected {
            guard let date = diaryList[indexPath.row].date?.formatted(
                Date.FormatStyle()
                    .hour()
                    .month(.abbreviated)
                    .day(.twoDigits)
            ) else { return }
            
            let alert = Alert.alertWithCompletions(
                style: .actionSheet,
                title: "Удалить тренеровку \(String(date))",
                actionTitleOne: "Отмена",
                actionTitleTwo: "да",
                completionOne: {},
                completionTwo: { self.deleteDateFromCoreData(indexPath) }
            )
            
            present(alert, animated: true)
            
        }
        if !editingStyleCustom {
            indexSelected = indexPath.row
        }
        
    }
    
    private func deleteDateFromCoreData(_ indexPath: IndexPath) {
        StorageManager.shared.delete(workoutNS: diaryList[indexPath.row])
        StorageManager.shared.saveContext()
        diaryList.remove(at: indexPath.row)
        
        mainCollectionView.reloadItems(at: [indexPath])
        mainTableView.reloadData()
    }
    
}

//MARK: - Set Table View
extension DiaryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Защита от краша при пустом дневнике
        if indexSelected < diaryList.count {
            guard let numberRows = diaryList[indexSelected].exercises?.count else { return 0 }
            return numberRows
        }
        
        // Защита от краша при удалении крайней даты из дневника
        if diaryList.count != 0 {
        indexSelected = diaryList.count - 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listDays", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        guard let exercisesNS = diaryList[indexSelected].exercises?.allObjects as? [ExercisesNS] else { return cell}
        
        content.text = exercisesNS[indexPath.row].descr
        content.secondaryText = exercisesNS[indexPath.row].numberOfRepetitions
        content.textProperties.color = #colorLiteral(red: 0, green: 0.798466444, blue: 0.9789896607, alpha: 0.7078630743)
        content.secondaryTextProperties.color = .gray
        cell.contentConfiguration = content
        cell.backgroundColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let exercisesNS = diaryList[indexSelected].exercises?.allObjects as? [ExercisesNS] else { return }
            StorageManager.shared.delete(exercisesNS: exercisesNS[indexPath.row])
            StorageManager.shared.saveContext()
            diaryList = Array(StorageManager.shared.fetchData().reversed())
            mainTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - Set size items
extension DiaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 40)
    }
}
