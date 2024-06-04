//
//  RealmManager.swift
//  TMSHomework-Lesson39
//
//  Created by Наталья Мазур on 4.05.24.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    weak var delegate: AlertDelegate?
    
    private init() { }
    
    var points: [Point] = []
    
    lazy var realm: Realm? = {
        do {
            let _realm = try Realm()
            return _realm
        } catch {
            delegate?.presentFailureAlert(error.localizedDescription)
            return nil
        }
    }()
    
    func savePoint(latitude: Double, longitude: Double, text: String) {
        let pointObject = Point(latitude: latitude, longitude: longitude, text: text)
        guard let realm = self.realm else {
            delegate?.presentFailureAlert("Something went wrong with database")
            return
        }
        
        do {
            try realm.write {
                realm.add(pointObject)
            }
            self.points.append(pointObject)
        } catch {
            delegate?.presentFailureAlert(error.localizedDescription)
        }
    }
    
    func deletePoint(id: ObjectId) {
        guard let realm else {
            delegate?.presentFailureAlert("Can't identify the car")
            return
        }
        
        do {
            let pointToDelete = realm.object(ofType: Point.self, forPrimaryKey: id)
            guard let pointToDelete else {
                
                return
            }
            try realm.write {
                realm.delete(pointToDelete)
            }
            
        } catch {
            delegate?.presentFailureAlert(error.localizedDescription)
        }
    }
    
    func readPoint(id: ObjectId) -> Point {
        guard let realm = RealmManager.shared.realm else {
            delegate?.presentFailureAlert("Something wrong with database")
            return Point(latitude: 0.0, longitude: 0.0, text: "nil")
        }
        
        return realm.object(ofType: Point.self, forPrimaryKey: id) ?? Point(latitude: 0.0, longitude: 0.0, text: "nil")
    }
    
    func readAllPointsFromDatabase() {
        guard let realm else {
            delegate?.presentFailureAlert("Can't get saved values")
            return
        }
        points = realm.objects(Point.self).map { $0 }
    }
}
