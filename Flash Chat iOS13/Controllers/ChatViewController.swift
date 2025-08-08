import UIKit
import Firebase

final class ChatViewController: UIViewController {
    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let inputContainerHeight: CGFloat = 80
        static let messageInputHeight: CGFloat = 44
        static let sendButtonSize: CGFloat = 44

        enum MessageInput {
            static let cornerRadius: CGFloat = 20
            static let horizontalPadding: CGFloat = 12
            static let verticalPadding: CGFloat = 18
        }

        enum SendButton {
            static let cornerRadius: CGFloat = 22
            static let trailing: CGFloat = 8
        }
    }

    var messages: [Message] = []
    let db = Firestore.firestore()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let placeholderStackView: UIStackView = {
        let title = UILabel()
        title.text = "🗨️ No Messages Yet"
        title.font = .systemFont(ofSize: 20, weight: .semibold)
        title.textColor = .secondaryLabel
        title.textAlignment = .center

        let subtitle = UILabel()
        subtitle.text = "Start the conversation below"
        subtitle.font = .systemFont(ofSize: 16)
        subtitle.textColor = .tertiaryLabel
        subtitle.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [title, subtitle])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let messageInputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type a message..."
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .label
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = Layout.MessageInput.cornerRadius
        textField.attributedPlaceholder = NSAttributedString(string: "Type a message...", attributes: [.foregroundColor: UIColor.placeholderText])
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "paperplane.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = Layout.SendButton.cornerRadius
        button.addTarget(self,
                         action: #selector(sendButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
        setupNavigationBar()
        setupTableView()
        loadMessages()
    }

    private func setupNavigationBar() {
        title = "💬 FlashChat"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 22, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.uturn.left"),
            style: .plain,
            target: self,
            action: #selector(signOut)
        )
        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChatViewCell.self, forCellReuseIdentifier: ChatViewCell.identifier)
        placeholderStackView.isHidden = !messages.isEmpty
    }

    private func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                self.messages.removeAll()

                if let error = error {
                    print("Error retrieving messages: \(error)")
                    return
                }

                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String,
                           let body = data[K.FStore.bodyField] as? String {
                            self.messages.append(Message(sender: sender, body: body))
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.placeholderStackView.isHidden = !self.messages.isEmpty
                    if !self.messages.isEmpty {
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }
    }

    @objc private func sendButtonTapped() {
        guard let body = messageInputTextField.text,
              let sender = Auth.auth().currentUser?.email else { return }

        db.collection(K.FStore.collectionName).addDocument(data: [
            K.FStore.senderField: sender,
            K.FStore.bodyField: body,
            K.FStore.dateField: Date().timeIntervalSince1970
        ]) { [weak self] error in
            if error == nil {
                DispatchQueue.main.async {
                    self?.messageInputTextField.text = ""
                }
            }
        }
    }

    @objc private func signOut() {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error signing out: \(error)")
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatViewCell.identifier, for: indexPath) as? ChatViewCell else {
            return UITableViewCell()
        }
        let message = messages[indexPath.row]
        let isCurrentUser = message.sender == Auth.auth().currentUser?.email
        cell.configure(with: message, author: isCurrentUser)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


private extension ChatViewController {

     func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(placeholderStackView)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(messageInputTextField)
        inputContainerView.addSubview(sendButton)
    }
    
    
     func setupConstraints() {
        NSLayoutConstraint.activate(
            [
            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            inputContainerView.heightAnchor.constraint(equalToConstant: Layout.inputContainerHeight),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor),

            placeholderStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            messageInputTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: Layout.MessageInput.horizontalPadding),
            messageInputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -Layout.SendButton.trailing),
            messageInputTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: Layout.MessageInput.verticalPadding),
            messageInputTextField.heightAnchor.constraint(equalToConstant: Layout.messageInputHeight),

            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -Layout.MessageInput.horizontalPadding),
            sendButton.centerYAnchor.constraint(equalTo: messageInputTextField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: Layout.sendButtonSize),
            sendButton.heightAnchor.constraint(equalToConstant: Layout.sendButtonSize)
        ])
    }
}
