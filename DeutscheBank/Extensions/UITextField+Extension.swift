//
//  UITextField+Extension.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit
import Combine

extension UITextField {
    
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func addToolbarButtonWith(title: String,
                              onPress: (target: Any, action: Selector),
                              barStyle: UIBarStyle = .black) {
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = barStyle
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: title, style: .plain, target: onPress.target, action: onPress.action)
        ]
        toolbar.sizeToFit()
        toolbar.layoutIfNeeded()
        self.inputAccessoryView = toolbar
    }
}
