//
//  AlertPresenter.swift
//  TMSHomework-Lesson39
//
//  Created by Наталья Мазур on 2.05.24.
//

import UIKit

struct AlertPresenter {
    
    static func present(from controller: UIViewController?, with text: String, message: String? = nil, actions: [UIAlertAction]? = nil, textFieldPlaceholder: String? = nil, style: UIAlertController.Style) {
        guard let controller = controller else {
            return
        }
        let alertVC = UIAlertController(title: text, message: message, preferredStyle: style)
        
        if let actions = actions {
            actions.forEach { action in
                alertVC.addAction(action)
            }
        }
        
        controller.present(alertVC, animated: true)
    }
}
