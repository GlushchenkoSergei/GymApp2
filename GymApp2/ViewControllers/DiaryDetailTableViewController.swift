//
//  DiaryDetailTableViewController.swift
//  GymApp2
//
//  Created by mac on 18.06.2022.
//

import UIKit

class DiaryDetailTableViewController: UITableViewController {

    var exercisesNS: [ExercisesNS]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exercisesNS.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryDetail", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = exercisesNS[indexPath.row].descr
        content.secondaryText = exercisesNS[indexPath.row].numberOfRepetitions
        content.image = UIImage(named: exercisesNS[indexPath.row].image ?? "002")

        content.textProperties.color = .red
        
        cell.contentConfiguration = content
        return cell
    }
}
