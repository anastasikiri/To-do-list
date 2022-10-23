//
//  Task.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-09.
//

import UIKit

class Alert {
   
    static func showBasic(title: String,
                          vc: UIViewController) {
        let alert = UIAlertController (title: title,
                                       message: nil,
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default)
        alert.addAction(okAction)
        vc.present(alert,animated: true)
    }
    
    static func showBasicWithTimer(title: String,
                                   vc: UIViewController) {
        let alert = UIAlertController (title: title,
                                       message: nil,
                                       preferredStyle: .alert)
        vc.present(alert,animated: true)
        
        let when = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true)
        }
    }
}
