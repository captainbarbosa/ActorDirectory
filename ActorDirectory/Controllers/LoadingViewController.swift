//
//  LoadingViewController.swift
//  ActorDirectory
//
//  Created by Nadia Barbosa on 12/15/20.
//

import UIKit

/**
 The `LoadingViewController` is resposible for displaying
 a "loading" state to the user.
 */
class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.systemIndigo

        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = UIColor.systemBackground
        view.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        activityIndicatorView.startAnimating()
    }
}
