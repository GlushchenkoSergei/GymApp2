//
//  SettingsViewController.swift
//  GymApp
//
//  Created by mac on 24.04.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let userDefaults = UserDefaults.standard

    @IBOutlet var numberOfStepper: UILabel!
    @IBOutlet var outletSegmentControl: UISegmentedControl!
    @IBOutlet var muscleSwitches: [MuscleSwitch]!
    
    @IBOutlet var outletStepper: UIStepper!
    
    private var muscleGroup = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValueControl()
        muscleSwitches[0].type = .breast
        muscleSwitches[1].type = .biceps
        muscleSwitches[2].type = .triceps
        muscleSwitches[3].type = .back
        muscleSwitches[4].type = .legs
        
        selectSegment()
    }
    
  //Функционал надо вынести в отдельные метод, а может даже в методы
    @IBAction func Stepper(_ sender: UIStepper) {
        let correctValue = Int(sender.value + 1)
        guard let valueBeforeUpdate = Int(numberOfStepper.text ?? "") else { return }
    
        if valueBeforeUpdate > correctValue {
            outletSegmentControl.removeSegment(at: correctValue, animated: true)
        }
        if  correctValue > valueBeforeUpdate {
            if sender.value == 1 {
                outletSegmentControl.insertSegment(withTitle: "Second", at: 1, animated: true)
            } else {
                outletSegmentControl.insertSegment(withTitle: "Three", at: 2, animated: true)
            }
        }
        
        outletSegmentControl.selectedSegmentIndex = 0
        
        numberOfStepper.text = "\(correctValue)"
    }
    
    
    @IBAction func segmentControl(_ sender: Any) {
        selectSegment()
    }
    
    private func selectSegment() {
        let currentSegment = outletSegmentControl.selectedSegmentIndex
        guard let titleCurrenSegment = outletSegmentControl.titleForSegment(at: currentSegment) else { return }
        let currentMuscle = userDefaults.array(forKey: titleCurrenSegment) as! [String]
        for muscleSwitch in muscleSwitches {
            if currentMuscle.contains(muscleSwitch.type.rawValue) {
                muscleSwitch.isOn = true
            } else {
                muscleSwitch.isOn = false
            }
        }
    }
    
    //функуионал надо вынести в отдельный метод, или методы
    @IBAction func tapSaveButton() {
        let currentSegment = outletSegmentControl.selectedSegmentIndex
        guard let titleCurrenSegment = outletSegmentControl.titleForSegment(at: currentSegment) else { return }
        setupMuscleGroup()
        
        //Dara for switch
        userDefaults.setValue(muscleGroup, forKey: titleCurrenSegment)
        
        //Dara for segmentControl
        let forUserDefaults: [Int] = [Int(numberOfStepper.text ?? "") ?? 0]
        userDefaults.setValue(forUserDefaults, forKey: "numberSegment")

        let alert = alert(with: "", and: "Настройки для \(titleCurrenSegment) тренеровки сохраненны")
        present(alert, animated: true)
    }
    
    
    private func setValueControl() {
        guard userDefaults.array(forKey: "numberSegment") != nil else { return }
        let values = userDefaults.array(forKey: "numberSegment") as! [Int]
        let value = values[0]
        numberOfStepper.text = "\(value)"
        outletStepper.value = Double(value - 1)
        
        outletSegmentControl.removeSegment(at: 2, animated: false)
        outletSegmentControl.removeSegment(at: 1, animated: false)
        
        switch value {
        case 1: return
        case 2: addSecond()
        default: addSecond()
                addThree()
        }
    }
    
    private func addSecond() {
        outletSegmentControl.insertSegment(withTitle: "Second", at: 1, animated: false)
    }
    private func addThree() {
        outletSegmentControl.insertSegment(withTitle: "Three", at: 2, animated: false)
    }
    
    private func setupMuscleGroup() {
        muscleGroup.removeAll()
        for muscleSwitch in muscleSwitches {
            if muscleSwitch.isOn {
                muscleGroup.append(muscleSwitch.type.rawValue)
            }
        }
    }
    
}


