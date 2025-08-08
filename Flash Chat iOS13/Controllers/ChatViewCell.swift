import UIKit

final class ChatViewCell: UITableViewCell {
    static let identifier = "MessageTableViewCell"
    
    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 12
        static let bubbleMaxWidth: CGFloat = 250
        static let bubbleMinHeight: CGFloat = 44
        static let cornerRadius: CGFloat = 18
        static let avatarSize: CGFloat = 32
        static let avatarLeading: CGFloat = 16
        static let bubbleToAvatarSpacing: CGFloat = 12
        static let timestampTopSpacing: CGFloat = 4
        static let cellVerticalSpacing: CGFloat = 8
    }
    
    private let bubbleBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Layout.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#333647")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let avatarYouImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .youAvatar)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Layout.avatarSize / 2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(hex: "#E0E0E0")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .meAvatar)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Layout.avatarSize / 2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(hex: "#E0E0E0")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hex: "#9E9E9E")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var bubbleLeadingConstraint: NSLayoutConstraint!
    private var bubbleTrailingConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        timestampLabel.text = nil
        bubbleLeadingConstraint.isActive = false
        bubbleTrailingConstraint.isActive = false
    }

    private func setupUI() {
        backgroundColor = UIColor.clear
        selectionStyle = .none

        bubbleBackgroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        bubbleBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bubbleBackgroundView.layer.shadowOpacity = 1
        bubbleBackgroundView.layer.shadowRadius = 3
    }

    func configure(with message: Message, author: Bool) {
        messageLabel.text = message.body
        timestampLabel.text = message.sender

        if author {
            configureAsComingMessage()
        } else {
            configureAsIncomingMessage()
        }
    
        bubbleLeadingConstraint.isActive = true
        bubbleTrailingConstraint.isActive = true
    }

    private func configureAsComingMessage() {

        messageLabel.textColor = UIColor(resource: .brandLightPurple)
        avatarImageView.isHidden = false
        avatarYouImageView.isHidden = true

        timestampLabel.textAlignment = .left

        bubbleBackgroundView.backgroundColor = UIColor(resource: .brandPurple)
        bubbleBackgroundView.layer.maskedCorners = [
            .layerMaxXMinYCorner,
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
    }

    private func configureAsIncomingMessage() {

        messageLabel.textColor = UIColor(resource: .brandPurple)
        avatarImageView.isHidden = true
        avatarYouImageView.isHidden = false

        timestampLabel.textAlignment = .right

        bubbleBackgroundView.backgroundColor = UIColor(resource: .brandLightPurple)
        bubbleBackgroundView.layer.maskedCorners = [
            .layerMaxXMinYCorner,
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
    }
}

private extension ChatViewCell {
    func addSubviews() {
            contentView.addSubview(avatarYouImageView)
            contentView.addSubview(avatarImageView)
            contentView.addSubview(bubbleBackgroundView)
            bubbleBackgroundView.addSubview(messageLabel)
            contentView.addSubview(timestampLabel)
    }

    func setupConstraints() {
            bubbleLeadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: avatarYouImageView.trailingAnchor, constant: Layout.bubbleToAvatarSpacing)
            bubbleTrailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -Layout.bubbleToAvatarSpacing)

            NSLayoutConstraint.activate(
                [
                    avatarYouImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.avatarLeading),
                    avatarYouImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.cellVerticalSpacing),
                    avatarYouImageView.widthAnchor.constraint(equalToConstant: Layout.avatarSize),
                    avatarYouImageView.heightAnchor.constraint(equalToConstant: Layout.avatarSize),
                    
                    avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.avatarLeading),
                    avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.cellVerticalSpacing),
                    avatarImageView.widthAnchor.constraint(equalToConstant: Layout.avatarSize),
                    avatarImageView.heightAnchor.constraint(equalToConstant: Layout.avatarSize),
                    
                    bubbleBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.cellVerticalSpacing),
                    bubbleBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: Layout.bubbleMaxWidth),
                    bubbleBackgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: Layout.bubbleMinHeight),
                    
                    messageLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: Layout.verticalPadding),
                    messageLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: Layout.horizontalPadding),
                    messageLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -Layout.horizontalPadding),
                    messageLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -Layout.verticalPadding),
                    
                    timestampLabel.topAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: Layout.timestampTopSpacing),
                    timestampLabel.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor),
                    timestampLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.cellVerticalSpacing),
                    timestampLabel.trailingAnchor.constraint(lessThanOrEqualTo: avatarImageView.leadingAnchor, constant: -Layout.bubbleToAvatarSpacing)
                ])
    }
}

