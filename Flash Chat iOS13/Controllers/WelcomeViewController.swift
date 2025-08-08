import UIKit

final class WelcomeViewController: UIViewController {
    private enum Layout {
        static let horizontalPadding: CGFloat = 40
        static let verticalSpacing: CGFloat = 24
        static let buttonHeight: CGFloat = 56
        static let logoSize: CGFloat = 120

        enum Logo {
            static let topOffset: CGFloat = 120
        }

        enum Title {
            static let topOffset: CGFloat = 48
        }

        enum Buttons {
            static let bottomOffset: CGFloat = 80
            static let spacing: CGFloat = 16
        }
    }
    

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hex: "#4FC3F7")
        let image = UIImage(systemName: "bolt.fill")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        label.textColor = UIColor(hex: "#4FC3F7")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(UIColor(hex: "#31AFC7"), for: .normal)
        button.backgroundColor = UIColor(hex: "#EAFBFF")
        button.layer.cornerRadius = 28
        button.addTarget(self,
                         action: #selector(registerButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#31AFC7")
        button.layer.cornerRadius = 28
        button.addTarget(self,
                         action: #selector(loginButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        
        addSubview()
        setupConstraints()
        titleAnimation()
    }


      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          setupNavigationBar()
      }
}



private extension WelcomeViewController {
    


@objc private func registerButtonTapped() {
    let registerViewController = RegisterViewController()
    navigationController?.pushViewController(registerViewController, animated: true)
}

@objc private func loginButtonTapped() {
    let loginFormViewController = LoginViewController()
    navigationController?.pushViewController(loginFormViewController, animated: true)
}

    
    
private func titleAnimation() {
    var charIndex = 0.0
    let titleText = K.appName
    for letter in titleText {
        Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { _ in
            self.titleLabel.text?.append(String(letter))
            
        }
        charIndex += 1
    }
}
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor(hex: "#F0F9FF").cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

private func setupNavigationBar() {
           let appearance = UINavigationBarAppearance()
           appearance.configureWithOpaqueBackground()
           appearance.backgroundColor = .white
           appearance.shadowImage = UIImage()
           appearance.shadowColor = .clear
           

           navigationController?.navigationBar.standardAppearance = appearance
           navigationController?.navigationBar.scrollEdgeAppearance = appearance
           navigationController?.navigationBar.compactAppearance = appearance
           if #available(iOS 15.0, *) {
               navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
           }
           
           navigationController?.navigationBar.tintColor = .black
           navigationController?.navigationBar.isTranslucent = true
           
           navigationController?.navigationBar.setNeedsLayout()
       }
}


private extension WelcomeViewController {
    private func addSubview() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(registerButton)
        view.addSubview(loginButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.Logo.topOffset),
            logoImageView.widthAnchor.constraint(equalToConstant: Layout.logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: Layout.logoSize),
            
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Layout.Title.topOffset),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: Layout.horizontalPadding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Layout.horizontalPadding),
            
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.horizontalPadding),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.horizontalPadding),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.Buttons.bottomOffset),
            loginButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight),
            
            
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.horizontalPadding),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.horizontalPadding),
            registerButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -Layout.Buttons.spacing),
            registerButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight)
        ])
    }
}


  

