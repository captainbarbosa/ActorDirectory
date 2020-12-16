//
//  ProfileImageView.swift
//  ActorDirectory
//
//  Created by Nadia Barbosa on 12/15/20.
//

import Foundation
import UIKit

/**
 The `ProfileImageView` class is responsible for
 loading a given image (optionally from a cache),
 and rendering it with a custom visual style.
 */
class ProfileImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .scaleAspectFill
        self.layer.borderColor = UIColor.systemIndigo.cgColor
        self.layer.borderWidth = 4.0
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Load the image using the `ImageCachingService`.

     If no image is provided or pulling from the cache fails,
     fall back to a default template image.
     */
    func loadImage(from url: URL?) {
        guard let photoURL = url else {
            self.image = UIImage(systemName: "smiley.fill")?.withTintColor(UIColor.lightGray, renderingMode: .alwaysOriginal)
            return
        }

        ImageCachingService.shared.loadImage(for: photoURL) { ( result ) in
            switch result {
            case .success(let profileImage):
                self.image = profileImage
            case .failure(_):
                self.image = UIImage(systemName: "smiley.fill")?.withTintColor(UIColor.lightGray, renderingMode: .alwaysOriginal)
            }
        }
    }
}

