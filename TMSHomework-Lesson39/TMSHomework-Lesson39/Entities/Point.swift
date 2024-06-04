//
//  Point.swift
//  TMSHomework-Lesson39
//
//  Created by Наталья Мазур on 4.05.24.
//

import Foundation
import RealmSwift

class Point: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var text: String
    
    convenience init(latitude: Double, longitude: Double, text: String) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
        self.text = text
    }
}
