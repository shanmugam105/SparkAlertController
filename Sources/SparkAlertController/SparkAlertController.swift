//
//  SparkAlertController.swift
//  SparkAlertController
//
//  Created by Sparkout on 04/10/22.
//

#if !os(macOS)
import UIKit
#endif

public protocol SparkAlertDelegate {
    func alertAction(for index: Int, alertController: SparkAlertController)
}

public struct SparkAlertConfiguration {
    public init(title: String,
                titleFont: UIFont = .systemFont(ofSize: 18, weight: .semibold),
                titleColor: UIColor = .black,
                message: String,
                messageFont: UIFont = .systemFont(ofSize: 16),
                messageColor: UIColor = .black,
                buttons: [String],
                buttonFont: UIFont = .systemFont(ofSize: 16, weight: .semibold),
                buttonColor: UIColor = .blue,
                buttonTitleColor: UIColor = .white) {
        self.title = title
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.message = message
        self.messageFont = messageFont
        self.messageColor = messageColor
        self.buttons = buttons
        self.buttonFont = buttonFont
        self.buttonColor = buttonColor
        self.buttonTitleColor = buttonTitleColor
    }
    
    let title: String
    public var titleFont: UIFont
    public var titleColor: UIColor
    let message: String
    public var messageFont: UIFont
    public var messageColor: UIColor
    let buttons: [ String ]
    public var buttonFont: UIFont
    public var buttonColor: UIColor
    public var buttonTitleColor: UIColor
}

public class SparkAlertController: UIViewController {
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let seperatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let seperatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    // StackView for action buttons
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    public var delegate: SparkAlertDelegate?
    public var configuration: SparkAlertConfiguration?
    
    public override func loadView() {
        super.loadView()
        configureView()
    }
    
    func configureView() {
        assert(configuration != nil, "Please add configuration")
        // 1. ContainerView
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 4
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        // 2. Title Label
        titleLabel.text = configuration?.title
        titleLabel.textColor = configuration?.titleColor
        titleLabel.font = configuration?.titleFont
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
        ])
        // 3. Seperator
        containerView.addSubview(seperatorView1)
        NSLayoutConstraint.activate([
            seperatorView1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            seperatorView1.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            seperatorView1.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            seperatorView1.heightAnchor.constraint(equalToConstant: 1)
        ])
        // 4. Message description
        messageDescriptionLabel.text = configuration?.message
        messageDescriptionLabel.textColor = configuration?.messageColor
        messageDescriptionLabel.font = configuration?.messageFont
        containerView.addSubview(messageDescriptionLabel)
        NSLayoutConstraint.activate([
            messageDescriptionLabel.topAnchor.constraint(equalTo: seperatorView1.bottomAnchor, constant: 8),
            messageDescriptionLabel.leadingAnchor.constraint(equalTo: seperatorView1.leadingAnchor, constant: 8),
            messageDescriptionLabel.trailingAnchor.constraint(equalTo: seperatorView1.trailingAnchor, constant: -8),
            messageDescriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        ])
        // 5. Seperator
        containerView.addSubview(seperatorView2)
        NSLayoutConstraint.activate([
            seperatorView2.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: 8),
            seperatorView2.leadingAnchor.constraint(equalTo: messageDescriptionLabel.leadingAnchor),
            seperatorView2.trailingAnchor.constraint(equalTo: messageDescriptionLabel.trailingAnchor),
            seperatorView2.heightAnchor.constraint(equalToConstant: 1)
        ])
        // 6. Action Buttons
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: seperatorView2.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: seperatorView2.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: seperatorView2.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        // 7. Action buttons
        configuration?.buttons.enumerated().forEach { index, title in
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.setTitleColor(configuration?.buttonTitleColor, for: .normal)
            button.backgroundColor = configuration?.buttonColor
            button.layer.cornerRadius = 4
            button.titleLabel?.font = configuration?.buttonFont
            button.tag = index
            button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func actionButtonTapped(_ sender: UIButton) {
        delegate?.alertAction(for: sender.tag, alertController: self)
    }
}
