//
//  TimerViewController.swift
//  GymApp2
//
//  Created by mac on 28.06.2022.
//

import UIKit

class TimerViewController: UIViewController {
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.text = ":"
        label.textColor = #colorLiteral(red: 0.1955762804, green: 0.1918440759, blue: 0.07235083729, alpha: 0.783088197)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var timerLabelIsOn = true
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.setTitle("Start", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 0.783088197)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let pickerViewMin: UIPickerView = {
        let picker = UIPickerView()
        let color = #colorLiteral(red: 0.8283011317, green: 0.8040949702, blue: 0.2841191888, alpha: 0.783088197)
        picker.setValue(color, forKey: "textColor")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let pickerViewSec: UIPickerView = {
        let picker = UIPickerView()
        let color = #colorLiteral(red: 0.8283011317, green: 0.8040949702, blue: 0.2841191888, alpha: 0.783088197)
        picker.setValue(color, forKey: "textColor")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private var timerOn = false
    private var pickerMin = 0
    private var pickerSec = 0
    private var timer = Timer()
    private var durationTimer = 0
    
    private let shapeLayer = CAShapeLayer()
    
    private var valuesForPicker: [Int] = {
        var array: [Int] = []
        for index in 0...59 {
            array.append(index)
        }
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBlurEffect()
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        view.addSubview(timerLabel)
        setConstrains()
        
        pickerViewMin.dataSource = self
        pickerViewMin.delegate = self
        pickerViewSec.dataSource = self
        pickerViewSec.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animationCircular()
    }
    
    @objc private func startButtonPressed() {
        if !timerOn {
            startButton.backgroundColor = .gray
            shapeLayer.strokeEnd = CGFloat(1)
            shapeLayer.speed = 1
            startButton.setTitle("Stop", for: .normal)
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            timerOn.toggle()
        } else {
            startButton.backgroundColor = #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 0.783088197)
            startButton.setTitle("Start", for: .normal)
            timerOn.toggle()
            shapeLayer.strokeEnd = CGFloat(0)
            shapeLayer.speed = 0
            timer.invalidate()
            
        }
    }
    
    @objc private func timerAction() {
        timerLabelIsOn.toggle()
        timerLabel.textColor = timerLabelIsOn ? #colorLiteral(red: 0.8283011317, green: 0.8040949702, blue: 0.2841191888, alpha: 0.783088197) : #colorLiteral(red: 0.1955762804, green: 0.1918440759, blue: 0.07235083729, alpha: 0.783088197)
        durationTimer -= 1
        pickerViewSec.selectRow(durationTimer % 60, inComponent: 0, animated: true)
        pickerViewMin.selectRow(durationTimer / 60, inComponent: 0, animated: true)
        
        if durationTimer <= 0 {
            timer.invalidate()
            timerOn.toggle()
            startButton.backgroundColor = #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 0.783088197)
            startButton.setTitle("Start", for: .normal)
        }
    }
    
    private func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }
    
    // MARK: - Animation
    private func animationCircular() {
        let center = CGPoint(x: view.center.x, y: view.center.y - view.frame.width / 2)
        
        let endAngle = 2.143 * CGFloat.pi
        let startAngle = (CGFloat.pi / 1.154)
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 130, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = circularPath.cgPath
        shapeLayer2.lineWidth = 26
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.strokeEnd = 1
        shapeLayer2.lineCap = CAShapeLayerLineCap.round
        shapeLayer2.strokeColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor
        view.layer.addSublayer(shapeLayer2)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 26
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 0.783088197).cgColor
        
        view.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
}

// MARK: - Picker Data Sorse, and Picker Delegate
extension TimerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        valuesForPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerViewMin {
            return String(valuesForPicker[row])
        } else {
            switch valuesForPicker[row] {
            case 0...9: return "0\(valuesForPicker[row])"
            default: return "\(valuesForPicker[row])"
            }
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !timerOn {
            switch pickerView {
            case pickerViewMin:
                pickerMin = valuesForPicker[row]
            case pickerViewSec:
                pickerSec = valuesForPicker[row]
            default: break
            }
            
            durationTimer = pickerMin * 60 + pickerSec
        }
    }
    
    
}

// MARK: - Set Constrains
extension TimerViewController {
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:  -view.frame.width / 2)
            
        ])
        
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        view.addSubview(pickerViewMin)
        NSLayoutConstraint.activate([
            pickerViewMin.centerYAnchor.constraint(equalTo: timerLabel.centerYAnchor),
            pickerViewMin.widthAnchor.constraint(equalToConstant: view.frame.width / 5),
            pickerViewMin.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30)
        ])
        
        view.addSubview(pickerViewSec)
        NSLayoutConstraint.activate([
            pickerViewSec.centerYAnchor.constraint(equalTo: timerLabel.centerYAnchor),
            pickerViewSec.widthAnchor.constraint(equalToConstant: view.frame.width / 5),
            pickerViewSec.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 30)
        ])
        
    }
}
