//
//  UIViewController+Extension.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/12.
//

import UIKit

extension UIViewController {
    func showAlertWith(
        title: String,
        message: String,
        firstButtonTitle: String? = nil,
        firstButtonStyle: UIAlertAction.Style = .default,
        secondButtonTitle: String? = nil,
        secondButtonStyle: UIAlertAction.Style = .default,
        withFirstCallback callBackFirst: ((UIAlertAction) -> Void)? = nil,
        withSecondCallback callBackSecond: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let firstButtonTitle = firstButtonTitle {
            alertController.addAction(UIAlertAction(title: firstButtonTitle,
                                                    style: firstButtonStyle,
                                                    handler: callBackFirst))
        }
        
        if let secondButtonTitle = secondButtonTitle {
            alertController.addAction(UIAlertAction(title: secondButtonTitle,
                                                    style: secondButtonStyle,
                                                    handler: callBackSecond))
        }
        present(alertController, animated: true, completion: nil)
    }
}
