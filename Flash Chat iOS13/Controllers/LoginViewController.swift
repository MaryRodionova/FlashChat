import UIKit
import Firebase

final class LoginViewController: UIViewController {
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
        textField.text = "1@2.com"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.textColor = UIColor(hex: "#333647")
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = Layout.Fields.cornerRadius
        textField.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 4)
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowRadius = 12
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
        textField.text = "123456"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.textColor = UIColor(hex: "#333647")
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = Layout.Fields.cornerRadius
        textField.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 4)
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowRadius = 12
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = Layout.Button.cornerRadius
        button.addTarget(self,
                         action: #selector(loginButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        setupGradientBackground()
        setupNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
}

private extension LoginViewController {

    @objc private func loginButtonTapped() {
        if let email = emailTextField.text,let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Error signing in: \(error.localizedDescription)")
                    return
                } else {
                    let chatViewController = ChatViewController()
                    self.navigationController?.pushViewController(chatViewController, animated: true)
                }
            }
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupNavigationBar() {
       let appearance = UINavigationBarAppearance()
       appearance.configureWithOpaqueBackground()
       appearance.backgroundColor = UIColor(hex: "#49C2F7")
       appearance.shadowImage = UIImage()
       appearance.shadowColor = .clear
      
       appearance.titleTextAttributes = [
           NSAttributedString.Key.foregroundColor: UIColor.white
       ]
       appearance.largeTitleTextAttributes = [
           NSAttributedString.Key.foregroundColor: UIColor.white
       ]

       navigationController?.navigationBar.standardAppearance = appearance
       navigationController?.navigationBar.scrollEdgeAppearance = appearance
       navigationController?.navigationBar.compactAppearance = appearance

       navigationController?.navigationBar.tintColor = .white
       navigationController?.navigationBar.isTranslucent = true
   }

   private func setupGradientBackground() {
       let gradientLayer = CAGradientLayer()
       gradientLayer.colors = [
           UIColor(hex: "#4FC3F7").cgColor,
           UIColor(hex: "#29B6F6").cgColor,
           UIColor(hex: "#03A9F4").cgColor
       ]
       gradientLayer.locations = [0.0, 0.5, 1.0]
       gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
       gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
       gradientLayer.frame = view.bounds
       view.layer.insertSublayer(gradientLayer, at: 0)
   }
}


// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
}

private extension LoginViewController {
     func addSubview() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
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
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Layout.Button.topOffset),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.horizontalPadding),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.horizontalPadding),
            loginButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight)
        ])
    }
}


