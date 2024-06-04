//
//  Double+Compare.swift
//  TMSHomework-Lesson39
//
//  Created by Наталья Мазур on 7.05.24.
//

import Foundation

extension Double {
    func isEqual(to other: Double, eps: Double = 1e-5) -> Bool {
        abs(self - other) < eps
    }
}
