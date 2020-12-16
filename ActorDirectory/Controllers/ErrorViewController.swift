//
//  ErrorViewController.swift
//  ActorDirectory
//
//  Created by Nadia Barbosa on 12/15/20.
//

import UIKit

/**
 The `ErrorViewController` is resposible for rendering an error
 state to the user.
 */
class ErrorViewController: UIViewController {

    var error: Error

    lazy var errorImage: UIImageView = {
        let errorImage = UIImage(systemName: "xmark.octagon.fill")?.withTintColor(UIColor.systemRed, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: errorImage)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var errorLabel: UILabel = {
        let errorLabel = UILabel(frame: CGRect.zero)
        errorLabel.lineBreakMode = .byTruncatingTail
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.text = error.localizedDescription
        return errorLabel
    }()

    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [errorImage, errorLabel])
        stack.spacing = 8.0
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()

    init(for error: Error) {
        self.error = error
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(stackView)

        activateConstraints()
    }

    func activateConstraints() {
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
