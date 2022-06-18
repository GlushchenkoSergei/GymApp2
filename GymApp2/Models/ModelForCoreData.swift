//
//  ModelForCoreData.swift
//  GymApp2
//
//  Created by mac on 18.06.2022.
//

import Foundation

struct ModelForCoreData {
    var data: Date
    var exercise: ModelForCoreData2
}


struct ModelForCoreData2 {
    var description: String
    var image: String
    var numberOfRepetitions: String
}
