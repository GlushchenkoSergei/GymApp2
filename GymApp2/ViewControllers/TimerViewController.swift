//
//  TimerViewController.swift
//  GymApp2
//
//  Created by mac on 28.06.2022.
//

import UIKit

class TimerViewController: UIViewController {
    
    private let timerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "shapeView")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.text = ":"
        label.textColor = #colorLiteral(red: 0.5924019217, green: 0.5919223428, blue: 0.6093741059, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        let color = #colorLiteral(red: 0.9879724383, green: 1, blue: 1, alpha: 1)
        picker.setValue(color, forKey: "textColor")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let pickerViewSec: UIPickerView = {
        let picker = UIPickerView()
        let color = #colorLiteral(red: 0.9879724383, green: 1, blue: 1, alpha: 1)
        picker.setValue(color, forKey: "textColor")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let shapeLayer = CAShapeLayer()
    
    private var timerLabelIsOn = true
    private var timerOn = false
    private var flagFirstStart = true
    
    private var beginnerValue: Int?
    
    private var pickerMin = 0
    private var pickerSec = 0
    private var timer = Timer()
    private var durationTimer = 0
    
    private var valuesForPicker: [Int] = {
        var array: [Int] = []
        for index in 0...59 {
            array.append(index)
        }
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        setBlurEffect()
        setConstrains()
        transformObjectsBeforeOpen()
        
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        
        pickerViewMin.dataSource = self
        pickerViewMin.delegate = self
        pickerViewSec.dataSource = self
        pickerViewSec.delegate = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animationCircular()
        Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(setColorForShapeLayer),
            userInfo: nil,
            repeats: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.4) { [unowned self] in
            self.timerImage.transform = .identity
            self.timerLabel.transform = .identity
            self.startButton.transform = .identity
            self.pickerViewMin.transform = .identity
            self.pickerViewSec.transform = .identity
            self.shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 0.783088197).cgColor
            self.view.alpha = 1
        }
    }
    
    private func transformObjectsBeforeOpen() {
        timerImage.transform = CGAffineTransform(translationX: 0, y: view.frame.height - 380).scaledBy(x: 0.1, y: 0.1)
        timerLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        startButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        pickerViewMin.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        pickerViewSec.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    
    @objc private func setColorForShapeLayer() {
            shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 0.783088197).cgColor
    }
    
    @objc private func startButtonPressed() {
        if !timerOn {
            if durationTimer != 0 {
            startButton.backgroundColor = .gray
            shapeLayer.speed = 1
            startButton.setTitle("Stop", for: .normal)
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            timerOn.toggle()
            }
        } else {
            startButton.backgroundColor = #colorLiteral(red: 0, green: 0.7945597768, blue: 0.9721226096, alpha: 0.783088197)
            startButton.setTitle("Start", for: .normal)
            timerOn.toggle()
            shapeLayer.strokeEnd = CGFloat(0)
            shapeLayer.speed = 0
            flagFirstStart.toggle()
            timer.invalidate()
        }
    }
    
    @objc private func timerAction() {
        timerLabelIsOn.toggle()
        timerLabel.textColor = timerLabelIsOn ? #colorLiteral(red: 0.5924019217, green: 0.5919223428, blue: 0.6093741059, alpha: 1) : #colorLiteral(red: 0.2606178522, green: 0.2613631189, blue: 0.2711788714, alpha: 1)
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
        let center = CGPoint(x: view.center.x, y: timerImage.center.y + view.frame.width * 0.072)
        
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(arcCenter: center, radius: view.frame.width * 0.335, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 7
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        // Настроить корректное отображение прогресса (при перезапуске)
        if flagFirstStart {
            beginnerValue = durationTimer
        shapeLayer.strokeEnd = 1
        } else {
            shapeLayer.strokeEnd = Double(durationTimer) / (Double(beginnerValue ?? 0) )
        }
        
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 0).cgColor
        
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
        
        view.addSubview(timerImage)
        NSLayoutConstraint.activate([
            timerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            timerImage.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            timerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerImage.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        view.addSubview(pickerViewMin)
        NSLayoutConstraint.activate([
            pickerViewMin.centerYAnchor.constraint(equalTo: timerImage.centerYAnchor, constant: view.frame.width * 0.071),
            pickerViewMin.widthAnchor.constraint(equalToConstant: view.frame.width / 5),
            pickerViewMin.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30)
        ])
        
        view.addSubview(pickerViewSec)
        NSLayoutConstraint.activate([
            pickerViewSec.centerYAnchor.constraint(equalTo: timerImage.centerYAnchor, constant: view.frame.width * 0.071),
            pickerViewSec.widthAnchor.constraint(equalToConstant: view.frame.width / 5),
            pickerViewSec.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 30)
        ])
        
        view.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: pickerViewSec.centerYAnchor, constant: -3)
        ])
    }
}
