//
//  UIViewController+Extension.swift
//  To-do list
//
//  Created by Anastasia Bilous on 2022-09-14.
//

import UIKit

extension UIViewController {
    
    class func loadFromStoryboard<T: UIViewController>(type: T.Type) -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: T.self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    func showBasicAlert(title: String, vc: UIViewController) {
        let alert = UIAlertController (title: title,
                                       message: nil,
                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        vc.present(alert,animated: true)
    }
    
    func showAlertWithTimer(title: String, vc: UIViewController) {
        let alert = UIAlertController (title: title,
                                       message: nil,
                                       preferredStyle: .alert)
        vc.present(alert,animated: true)
        
        let when = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true)
        }
    }
    
    func parse(_ error: APIHelper.ErrorAPI) -> String {
        var message = String()
        
        switch error {
        case let .badRequest(msg):
            message = msg
        case let .unauthorized(msg):
            message = msg
            self.navigationController?.popToRootViewController(animated: true)
        case let .others(msg):
            message = msg
        }
        return message
    }
}
