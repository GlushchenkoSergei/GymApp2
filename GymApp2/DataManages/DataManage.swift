//
//  DataManage.swift
//  GymApp
//
//  Created by mac on 23.04.2022.
//

import Foundation

class DataManage {
    
    static let shared = DataManage()
    
    var exercises: [Exercise] = [
        Exercise(description: "Жим штанги на ровной скамье", image: "benchPress", numberOfRepetitions: "10 x 4", muscle: .breast),
        Exercise(description: "Жим штанги на скамье с уклоном в верх", image: "benchPressN", numberOfRepetitions: "10 x 4", muscle: .breast),
        Exercise(description: "Разводка гантелей", image: "razvodka", numberOfRepetitions: "10 x 3", muscle: .breast),
        Exercise(description: "Бабочка", image: "butterfly", numberOfRepetitions: "12 x 4", muscle: .breast),
        Exercise(description: "Подъем гантерей на бицепс", image: "basicArm", numberOfRepetitions: "12 x 4", muscle: .biceps),
        Exercise(description: "Молотки", image: "hammers", numberOfRepetitions: "12 x 4", muscle: .biceps),
        Exercise(description: "Подтягивания обратным хватом", image: "pullUpsToggle", numberOfRepetitions: "", muscle: .biceps),
        Exercise(description: "Тяга нижнего блока", image: "thrustT", numberOfRepetitions: "15 x 3", muscle: .biceps),
        Exercise(description: "Брусья", image: "bars", numberOfRepetitions: "До отказа x 3", muscle: .triceps),
        Exercise(description: "Тяга верхнего блока на трицепс", image: "thrustT", numberOfRepetitions: "Индивидуально x 4", muscle: .triceps),
        Exercise(description: "Обратные отжимания на скамье", image: "pushUpsBack", numberOfRepetitions: "15 x 4", muscle: .triceps),
        Exercise(description: "Жим гантелей из за головы", image: "pullover", numberOfRepetitions: "10 x 4", muscle: .triceps),
        Exercise(description: "Тяга блока к животу", image: "lowerLink", numberOfRepetitions: "15 x 4", muscle: .back),
        Exercise(description: "Тяга верхнего блока к груди", image: "topPull", numberOfRepetitions: "15 x 3", muscle: .back),
        Exercise(description: "Подтягивания прямым хватом", image: "pullUpsStandart", numberOfRepetitions: "Индивидуально", muscle: .back),
        Exercise(description: "Становая тяга", image: "basic1", numberOfRepetitions: "8 х 3", muscle: .back),
        Exercise(description: "Приседания со штангой", image: "basic3", numberOfRepetitions: "8 х 3", muscle: .legs),
        Exercise(description: "Выпады", image: "lunges", numberOfRepetitions: "Индивидуально х 4", muscle: .legs),
        Exercise(description: "Сведение ног в тренажере", image: "003", numberOfRepetitions: "Индивидуально", muscle: .legs),
        Exercise(description: "Подъемы на носке", image: "002", numberOfRepetitions: "20 х 4", muscle: .legs)
    ]
    
    private init() {}
}


