//
//  Kayit.swift
//  KisiTakip
//
//  Created by Macbook on 28/05/2024.
//

import UIKit
import Combine
class Kayit: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    private var viewModel = KayitViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
       }

       private func setupBindings() {
           // Kullanıcı adı, şifre, e-posta ve telefon alanlarını ViewModel'e bağlayın
           usernameTextField.textPublisher
               .assign(to: \.username, on: viewModel)
               .store(in: &cancellables)

           passwordTextField.textPublisher
               .assign(to: \.password, on: viewModel)
               .store(in: &cancellables)

           emailTextField.textPublisher
               .assign(to: \.email, on: viewModel)
               .store(in: &cancellables)

           phoneTextField.textPublisher
               .assign(to: \.phone, on: viewModel)
               .store(in: &cancellables)

           // Hata mesajını gözlemleme
           viewModel.$errorMessage
               .sink { [weak self] errorMessage in
                   self?.errorLabel.text = errorMessage
               }
               .store(in: &cancellables)

           // Kayıt başarı durumunu gözlemleyin
           viewModel.$registrationSuccess
               .sink { [weak self] success in
                   if success {
                       self?.navigationController?.popViewController(animated: true)
                   }
               }
               .store(in: &cancellables)
    }
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        viewModel.registerUser()
    }
    private func navigateToHomePage() {
            // Bu fonksiyon ana sayfaya yönlendirme işlemini gerçekleştirir.
            // Örneğin, ana sayfa `Anasayfa` olarak adlandırılmışsa:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let homeVC = storyboard.instantiateViewController(identifier: "Anasayfa") as? Anasayfa {
                homeVC.modalPresentationStyle = .fullScreen
                self.present(homeVC, animated: true, completion: nil)
            }
        }
    }

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}


