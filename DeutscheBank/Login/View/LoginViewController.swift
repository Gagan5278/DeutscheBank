//
//  ViewController.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit
import Combine
class LoginViewController: UIViewController {
    
    var loginCoordinator: Coordinator?
    private var userIDTextFieldSubscriber: AnyCancellable?
    private let userTextFieldHeight: CGFloat = AppConstants.commonPaadingConstants*4.4
    private let loginButtonHeight: CGFloat = AppConstants.commonPaadingConstants*4.4

    public private(set) lazy var userIDEntryTextField: UITextField = {
        let txtField = UITextField()
        txtField.borderStyle = .roundedRect
        txtField.keyboardType = .numberPad
        txtField.addBorder()
        txtField.addToolbarButtonWith(title: AppConstants.LoginScreenConstants.textFieldToolbarButtonTitle, onPress: (
            target: self,
            action: #selector(doneButtonAction))
        )
        // add a tap Gesture Recognizer
        self.view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(doneButtonAction))
        )
        return txtField
    }()
    
    public private(set)lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = AppConstants.LoginScreenConstants.loginButtonTitle
        let btn = UIButton(configuration: configuration, primaryAction: nil)
        btn.setTitle(
            AppConstants.LoginScreenConstants.loginButtonTitle,
            for: .normal
        )
        btn.addTarget(
            self,
            action: #selector(nextButtonAction),
            for: .touchUpInside
        )
        btn.isEnabled = false
        return btn
    }()
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewsOnMainView()
        addTextFieldSubscriber()
        addTapGestureToHideKeyboard()
    }
    
    // MARK: - TextField event subscriber/listner
    private func addTextFieldSubscriber() {
        userIDTextFieldSubscriber = userIDEntryTextField
            .textPublisher()
            .map({ $0.integer != nil })
            .assign(to: \.isEnabled, on: loginButton)
    }
    
    // MARK: - Add Views in main view
    private func addViewsOnMainView() {
        self.view.addSubviews(userIDEntryTextField, loginButton)
        userIDTextFieldConstraintSetup()
        loginButtonConstraintSetup()
    }
    
    private func userIDTextFieldConstraintSetup() {
        userIDEntryTextField.anchor(
            top: nil,
            leading: self.view.leadingAnchor,
            bottom: nil,
            trailing: self.view.trailingAnchor,
            padding: UIEdgeInsets(
                top: 0,
                left: AppConstants.commonPaadingConstants,
                bottom: 0,
                right: AppConstants.commonPaadingConstants
            ),
            size: CGSize(
                width: 0,
                height: userTextFieldHeight
            )
        )
        userIDEntryTextField.addViewInCenterVertically()
    }

    private func loginButtonConstraintSetup() {
         loginButton.anchor(
            top: userIDEntryTextField.bottomAnchor,
            leading: self.view.leadingAnchor,
            bottom: nil,
            trailing: self.view.trailingAnchor,
            padding: UIEdgeInsets(
                top: 2*AppConstants.commonPaadingConstants,
                left: AppConstants.commonPaadingConstants,
                bottom: 0,
                right: AppConstants.commonPaadingConstants
            ),
            size: CGSize(
                width: 0,
                height: loginButtonHeight
            )
        )
    }
    
    private func addTapGestureToHideKeyboard() {
        // add a tap Gesture Recognizer
        self.view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(doneButtonAction))
        )
    }
    
    // MARK: - Hide Keyboard
    @objc private func doneButtonAction() {
        userIDEntryTextField.resignFirstResponder()
    }
    
    // MARK: - Next Button Action
    @objc private func nextButtonAction(sender: UIAction?) {
        if let userID = userIDEntryTextField.text?.integer {
            loginCoordinator?.pushToShowPostsFor(userID: userID)
        }
    }
}
