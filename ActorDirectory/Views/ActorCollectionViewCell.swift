//
//  ActorCollectionViewCell.swift
//  ActorDirectory
//
//  Created by Nadia Barbosa on 12/15/20.
//

import UIKit

/**
 The `ActorCollectionViewCell` is responsible for rendering
 required and optional information about a given actor.
 */
class ActorCollectionViewCell: UICollectionViewCell {

    // MARK: - Cell UI Elements
    lazy var photoNameStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImage, nameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        return stackView
    }()

    lazy var actorDetailsStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect.zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.distribution = .fillProportionally
        return stackView
    }()

    lazy var profileImage: ProfileImageView = {
        let imageView = ProfileImageView(frame: CGRect.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        return label
    }()

    lazy var teamLabel: ImageLabel = {
        let label = ImageLabel(frame: CGRect.zero, systemImageName: "person.2.fill")
        return label
    }()

    lazy var emailLabel: ImageLabel = {
        let label = ImageLabel(frame: CGRect.zero, systemImageName: "envelope")
        return label
    }()

    lazy var phoneLabel: ImageLabel = {
        let label = ImageLabel(frame: CGRect.zero, systemImageName: "phone")
        return label
    }()

    lazy var bioLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        /**
         When using italic text, `UIFont.systemFontSize` is smaller than
         non-italic text, so the size is made larger here to make it apppear
         more visually consistent with the other label text.
         */
        label.font = UIFont.italicSystemFont(ofSize: 18.0)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.backgroundColor = UIColor.systemBackground

        addSubview(photoNameStack)
        actorDetailsStackView.addArrangedSubview(teamLabel)
        actorDetailsStackView.addArrangedSubview(emailLabel)
        actorDetailsStackView.addArrangedSubview(phoneLabel)
        actorDetailsStackView.addArrangedSubview(bioLabel)
        contentView.addSubview(actorDetailsStackView)

        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func activateConstraints() {
        NSLayoutConstraint.activate([
            /**
             The photoNameStack is a fixed height within the cell's content view.
             This is to allow for the profile image to be at a consistent height.
             */
            photoNameStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            photoNameStack.heightAnchor.constraint(equalToConstant: 80.0),
            photoNameStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.90),
            photoNameStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImage.widthAnchor.constraint(equalTo: photoNameStack.heightAnchor),

            /**
             The actorDetailsStackView is pinned to the bottom of the photoNameStack,
             and takes up up% pf the cell content width.
             */
            actorDetailsStackView.topAnchor.constraint(equalTo: photoNameStack.bottomAnchor, constant: 12.0),
            actorDetailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            actorDetailsStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            actorDetailsStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.90)
        ])
    }
}
