//
//  ImageLabel.swift
//  ActorDirectory
//
//  Created by Nadia Barbosa on 12/15/20.
//

import UIKit

/**
 The `ImageLabel` class is responsible for rendering a label
 alongside a given SF Symbol image.
 */
class ImageLabel: UILabel {

    var systemImageName: String

    /**
     When the label's text property is set, regenerate
     the attributed string with the given SF Symbol image.
     */
    override var text: String? {
        willSet {
            self.attributedText = nil
        }

        didSet {
            guard let newValue = self.text else { return }
            updateAttributedString(with: newValue)
        }
    }

    init(frame: CGRect, systemImageName: String) {
        self.systemImageName = systemImageName
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateAttributedString(with text: String) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: systemImageName)?.withTintColor(UIColor.label, renderingMode: .alwaysOriginal)

        let attributes = [NSMutableAttributedString.Key.foregroundColor : UIColor.label]

        let mutableAttributedString = NSMutableAttributedString(string: " \(text)", attributes: attributes)
        mutableAttributedString.insert(NSAttributedString(attachment: imageAttachment), at: 0)

        self.attributedText = mutableAttributedString
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
}
