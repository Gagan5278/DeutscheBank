//
//  ViewController.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/11.
//

import UIKit
import Combine
class LoginViewController: BaseViewController {
    
    var loginCoordinator: Coordinator?
    private var userIDTextFieldSubscriber: AnyCancellable?
    private let userTextFieldHeight: CGFloat = AppConstants.commonPadingConstants*4.4
    private let loginButtonHeight: CGFloat = AppConstants.commonPadingConstants*4.4
    private var loginViewModel: LoginViewViewModel!

    public private(set) lazy var userIDEntryTextField: UITextField = {
        let txtField = UITextField()
        txtField.borderStyle = .roundedRect
        txtField.keyboardType = .numberPad
        txtField.placeholder = AppConstants.LoginScreenConstants.textFieldPlaceHolder
        txtField.addBorder()
        txtField.addToolbarButtonWith(title: AppConstants.LoginScreenConstants.textFieldToolbarButtonTitle, onPress: (
            target: self,
            action: #selector(doneButtonAction))
        )
        txtField.heightAnchor.constraint(equalToConstant: userTextFieldHeight).isActive = true
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
        btn.heightAnchor.constraint(equalToConstant: loginButtonHeight).isActive = true
        btn.isEnabled = false
        return btn
    }()
    
    private lazy var verticalStackView: VerticalStackView = {
        let stackView = VerticalStackView(views: userIDEntryTextField, loginButton)
        return stackView
    }()
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = AppConstants.LoginScreenConstants.navigationTitle
        addViewsOnMainView()
        addTextFieldSubscriber()
        addTapGestureToHideKeyboard()
        displayAlertIfNoInterentAccessibility()
    }
    
    convenience init(viewModel: LoginViewViewModel) {
        self.init(nibName: nil, bundle: nil)
        loginViewModel = viewModel
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetUserEntryStateOnViewWillDisappear()
    }
     
    // MARK: - TextField event subscriber/listner
    private func addTextFieldSubscriber() {
        userIDTextFieldSubscriber = loginViewModel
            .validateEnteredUserID(userIDEntryTextField.textPublisher())
            .assign(
                to: \.isEnabled,
                on: loginButton
            )
    }
    
    // MARK: - Add Views in main view
    private func addViewsOnMainView() {
        self.view.addSubviews(verticalStackView)
        verticalStackViewConstraintSetup()
    }
    
    private func verticalStackViewConstraintSetup() {
        verticalStackView.anchor(
            top: nil,
            leading: self.view.leadingAnchor,
            bottom: nil, trailing: self.view.trailingAnchor,
            padding: UIEdgeInsets(
                top: 0,
                left: AppConstants.commonPadingConstants,
                bottom: 0,
                right: AppConstants.commonPadingConstants)
        )
        verticalStackView.centerInSuperview()
    }
    
    private func addTapGestureToHideKeyboard() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(doneButtonAction))
        )
    }
    
    private func displayAlertIfNoInterentAccessibility() {
        checkForInternetAndShowAlertOnStart(
            with: AppConstants.netowrkErrorAlertTitle,
            message: AppConstants.netowrkErrorAlertMessage
        )
    }
    
    // MARK: - Hide Keyboard
    @objc
    private func doneButtonAction() {
        userIDEntryTextField.resignFirstResponder()
    }
    
    private func resetUserEntryStateOnViewWillDisappear() {
        doneButtonAction()
        userIDEntryTextField.text = ""
        loginButton.isEnabled = false
    }
    
    // MARK: - Next Button Action
    @objc
    private func nextButtonAction(sender: UIAction?) {
        if let userID = userIDEntryTextField.text?.integer {
            loginCoordinator?.pushToShowPostsFor(userID: userID)
        }
    }
}
