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
    
    private var editingStyle = false
    
    var oldAndNewSelectedIndex: [IndexPath] = []
    
    var indexSelected = 0 {
        willSet {
            oldAndNewSelectedIndex.removeAll()
            oldAndNewSelectedIndex.append(createIndexPath(newValue))
               }
        didSet {
            mainTableView.reloadData()
            oldAndNewSelectedIndex.append(createIndexPath(oldValue))
            mainCollectionView.reloadItems(at: oldAndNewSelectedIndex)
        }
    }

    //данные кор дата
    private let diaryList = Array(StorageManager.shared.fetchData().reversed())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mainTableView.rowHeight = 60
        title = "Дневник тренировок"
        setRightButtonItem()
        
    }
    
    private func createIndexPath(_ value: Int) -> IndexPath {
       IndexPath(row: value, section: 0)
    }
    
    private func setRightButtonItem() {
        let edit = UIBarButtonItem(title: editingStyle ? "Done" : "Edit",
                                    style: .done,
                                    target: self,
                                    action: #selector(editAction))
        navigationItem.setRightBarButtonItems([edit], animated: true)
    }
    
    @objc private func editAction() {
        mainTableView.isEditing = editingStyle ? false : true
        mainCollectionView.isEditing = editingStyle ? false : true
        editingStyle.toggle()
        
        setRightButtonItem()
    }

}
//MARK: - Set Collection View
extension DiaryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateViewCell
        cell.labelDate.textColor = .black
        cell.backgroundColor = indexPath.row == indexSelected ? #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1) : #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 0.38)
        cell.labelDate.text = diaryList[indexPath.row].date?.formatted(
            Date.FormatStyle()
                    .year(.defaultDigits)
                    .month(.abbreviated)
                    .day(.twoDigits)
        )
        cell.layer.cornerRadius = cell.frame.height / 4
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if editingStyle {
            print("fffff")
        } else {
            indexSelected = indexPath.row
        }
    }
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    
}

//MARK: - Set Table View
extension DiaryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !diaryList.isEmpty {
            guard let numberRows = diaryList[indexSelected].exercises?.count else { return 0}
            return numberRows
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        true
    //    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("удалил")
        }
    }
    
}

//MARK: - Set size items
extension DiaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 40)
    }
}
