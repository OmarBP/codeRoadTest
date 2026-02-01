//
//  NetworkActivityView.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 31/01/26.
//

import UIKit

typealias AlertAction = () -> Void

protocol NetworkActivityView: NSObject {
    var activityIndicator: UIActivityIndicatorView! { get set }
    
    func setUpActivityIndicator(in view: UIView)
    func showErrorAlert(in vc: UIViewController, message: String, action: AlertAction?)
}

extension NetworkActivityView {
    func setUpActivityIndicator(in view: UIView) {
        let activityIndicatorFrame = CGRect(x: 0, y: 0, width: 70, height: 70)
        activityIndicator = UIActivityIndicatorView(frame: activityIndicatorFrame)
        activityIndicator.style = .large
        activityIndicator.center = view.center
        activityIndicator.color = .white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func showErrorAlert(in vc: UIViewController, message: String, action: AlertAction? = nil) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .cancel) { _ in
            action?()
        }
        alert.addAction(closeAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
