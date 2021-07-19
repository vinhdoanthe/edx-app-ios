//
//  ValuePropMessageView.swift
//  edX
//
//  Created by Muhammad Umer on 08/12/2020.
//  Copyright © 2020 edX. All rights reserved.
//

import Foundation

protocol ValuePropMessageViewDelegate {
    func showValuePropDetailView()
}

class ValuePropComponentView: UIView {
    
    typealias Environment = OEXStylesProvider
        
    var delegate: ValuePropMessageViewDelegate?
        
    private let imageSize: CGFloat = 20
    
    private lazy var container = UIView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private lazy var upgradeButton: ValuePropUpgradeButtonView = {
       let button = ValuePropUpgradeButtonView()
        button.tapAction = { [weak self] in
            if let controller = self?.firstAvailableUIViewController() {
                controller.showOverlay(withMessage: "Payments are coming soon")
            }
        }
        return button

    }()
    private lazy var lockImageView = UIImageView()
    
    private lazy var titleStyle: OEXMutableTextStyle = {
        return OEXMutableTextStyle(weight: .bold, size: .small, color: environment.styles.neutralBlack())
    }()
    
    private lazy var messageStyle: OEXMutableTextStyle = {
        return OEXMutableTextStyle(weight: .normal, size: .base, color: environment.styles.neutralXXDark())
    }()

    private let environment: Environment

    init(environment: Environment) {
        self.environment = environment
        super.init(frame: .zero)
        
        setupViews()
        setConstraints()
        setAccessibilityIdentifiers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        container.addShadow(offset: CGSize(width: 0, height: 2), color: OEXStyles.shared().primaryDarkColor(), radius: 2, opacity: 0.35, cornerRadius: 5)
    }

    private func setupViews() {
        container.backgroundColor = environment.styles.neutralWhite()

        lockImageView.image = Icon.Closed.imageWithFontSize(size: imageSize).image(with: environment.styles.primaryDarkColor())
        titleLabel.attributedText = titleStyle.attributedString(withText: Strings.ValueProp.assignmentsAreLocked)
        let attributedMessage = messageStyle.attributedString(withText: Strings.ValueProp.upgradeToAccessGraded)
        messageLabel.attributedText = attributedMessage.setLineSpacing(8)

        container.addSubview(titleLabel)
        container.addSubview(messageLabel)
        container.addSubview(lockImageView)
        container.addSubview(upgradeButton)
        addSubview(container)
    }
    
    private func setConstraints() {
        container.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self).offset(StandardHorizontalMargin)
            make.trailing.equalTo(self).inset(StandardHorizontalMargin)
            make.bottom.equalTo(upgradeButton).offset(StandardVerticalMargin * 2)
        }
        
        lockImageView.snp.makeConstraints { make in
            make.top.equalTo(StandardVerticalMargin * 2)
            make.leading.equalTo(container).offset(StandardHorizontalMargin + 3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(lockImageView)
            make.leading.equalTo(lockImageView).offset(imageSize+10)
            make.trailing.equalTo(container)
            make.width.equalTo(container)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(StandardVerticalMargin * 2)
            make.leading.equalTo(container).offset(StandardHorizontalMargin)
            make.trailing.equalTo(container).inset(StandardHorizontalMargin)
        }

        upgradeButton.snp.makeConstraints { make  in
            make.leading.equalTo(container).offset(StandardHorizontalMargin)
            make.trailing.equalTo(container).inset(StandardHorizontalMargin)
            make.top.equalTo(messageLabel.snp.bottom).offset(StandardVerticalMargin * 2)
            make.height.equalTo(ValuePropUpgradeButtonView.height)
        }
    }
    
    private func setAccessibilityIdentifiers() {
        accessibilityIdentifier = "ValuePropMessageView:view"
        lockImageView.accessibilityIdentifier = "ValuePropMessageView:image-view-lock"
        titleLabel.accessibilityIdentifier = "ValuePropMessageView:label-title"
        messageLabel.accessibilityIdentifier = "ValuePropMessageView:label-message"
        upgradeButton.accessibilityIdentifier = "ValuePropMessageView:upgrade-button"
    }
}