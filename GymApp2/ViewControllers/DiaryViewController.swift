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
    
    var indexSelected = 0

    //данные кор дата
    private let diaryList = Array(StorageManager.shared.fetchData().reversed())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.rowHeight = 60
        title = "Дневник тренировок"
        setRightButtonItem()
    }
    
    private func setRightButtonItem() {
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction))
       navigationItem.setRightBarButtonItems([edit], animated: true)
    }
    
    @objc private func editAction() {
       // Изменение даты и удаление записи тренеровки
    }
    
}
//MARK: - Set Collection View
extension DiaryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateViewCell
        cell.backgroundColor = #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 0.38)
        cell.labelDate.textColor = .black
        cell.labelDate.text = diaryList[indexPath.row].date?.formatted(
            Date.FormatStyle()
                    .year(.defaultDigits)
                    .month(.abbreviated)
                    .day(.twoDigits)
        )
        cell.layer.cornerRadius = cell.frame.height / 4
        return cell
    }
    
}

//MARK: - Set Table View
extension DiaryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberRows = diaryList[indexSelected].exercises?.count else { return 0}
       return numberRows
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
    
}

extension DiaryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 40)
    }
}
