//
//  Model.swift
//  GymApp
//
//  Created by mac on 23.04.2022.
//

import Foundation
import CoreText

struct Exercise {
    var description: String
    var image: String
    var numberOfRepetitions: String
    let muscle: MuscleGroup
}

enum MuscleGroup: String {
    case biceps = "Бицепс"
    case triceps = "Трицепс"
    case breast = "Грудь"
    case back = "Спина"
    case legs = "Ноги"
}
