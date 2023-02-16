//
//  BaseViewController.swift
//  DeutscheBank
//
//  Created by Gagan Vishal  on 2023/02/13.
//

import UIKit

class BaseViewController: UIViewController {

    private let activityIndicator: UIActivityIndicatorView = {
        let actView  = UIActivityIndicatorView()
        actView.hidesWhenStopped = true
        return actView
    }()
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubviewToFront(activityIndicator)
    }
    
   // MARK: - Activity indicator setup
    private func setupActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }
    
    func startActivityIndicatorAnimation() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicatorAnimation() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Check for internet and show alert if not available
    func checkForInternetAndShowAlertOnStart(with title: String, message: String) {
        if !NetworkReachability.isConnectedToNetwork() {
            presentNoNetworkErrorAlert(
                title: title,
                message: message
            )
        }
    }
    
    private func presentNoNetworkErrorAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlertWith(
                title: title,
                message: message,
                firstButtonTitle: AppConstants.netowrkErrorAlertButtonTitle
            )
        }
    }
}
