//
//  NetworkActivityView.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 31/01/26.
//

import UIKit

typealias AlertAction = () -> Void

/**
 Protocol that set some common UI elements for views that perform network calls
 */
protocol NetworkActivityView: NSObject {
    var activityIndicator: UIActivityIndicatorView! { get set }
    
    /**
     Generates an activity indicator that will appear on the center of the view
     
     - Parameters:
        - view: The view where the activity indicator will appear
     */
    func setUpActivityIndicator(in view: UIView)
    /**
     Generates an alert that will appear when needed
     
     - Parameters:
        - vc: The view controller where the alert will appear
        - message: The message that will appear on the body of the alert
        - action: The action that will be performed when the user interacts with the unique action of the alert
     */
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
