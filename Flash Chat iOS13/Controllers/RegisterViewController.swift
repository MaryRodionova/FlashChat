import UIKit
import Firebase

final class RegisterViewController: UIViewController {
    private enum Layout {
        static let horizontalPadding: CGFloat = 40
        static let fieldHeight: CGFloat = 56
        static let buttonHeight: CGFloat = 56
        static let verticalSpacing: CGFloat = 20

        enum Fields {
            static let topOffset: CGFloat = 120
            static let cornerRadius: CGFloat = 28
        }
        
        enum Button {
            static let topOffset: CGFloat = 40
            static let cornerRadius: CGFloat = 28
        }
    }

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.textColor = UIColor(hex: "#333647")
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = Layout.Fields.cornerRadius
        textField.layer.shadowColor = UIColor(hex: "#E3F2FD").cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowOpacity = 0.3
        textField.layer.shadowRadius = 8
        textField.borderStyle = .none
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.textColor = UIColor(hex: "#333647")
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = Layout.Fields.cornerRadius
        textField.layer.shadowColor = UIColor(hex: "#E3F2FD").cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowOpacity = 0.3
        textField.layer.shadowRadius = 8
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(UIColor(hex: "#4FC3F7"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = Layout.Button.cornerRadius
        button.addTarget(self,
                         action: #selector(registerButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        setupActions()
        setupGradientBackground()
        setupNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor(hex: "#4FC3F7")
    }

    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#F5F9FF").cgColor,
            UIColor(hex: "#E8F4FD").cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

private extension RegisterViewController {
    
    private func setupActions() {
        setupTextFieldDelegates()
    }

    private func setupTextFieldDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @objc private func registerButtonTapped() {
        if let email = emailTextField.text,let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    let registerViewController = ChatViewController()
                    self.navigationController?.pushViewController(registerViewController, animated: true)

                }
            }
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}


// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            registerButtonTapped()
        }
        return true
    }
}

private extension RegisterViewController {
    
     func addSubview() {
        view.backgroundColor = UIColor(hex: "#F5F9FF")
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
    }

     func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.Fields.topOffset),
                emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.horizontalPadding),
                emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.horizontalPadding),
                emailTextField.heightAnchor.constraint(equalToConstant: Layout.fieldHeight),
                
                
                passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: Layout.verticalSpacing),
                passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.horizontalPadding),
                passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.horizontalPadding),
                passwordTextField.heightAnchor.constraint(equalToConstant: Layout.fieldHeight),
                
                
                registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Layout.Button.topOffset),
                registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.horizontalPadding),
                registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.horizontalPadding),
                registerButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight)
            ])
    }
}




