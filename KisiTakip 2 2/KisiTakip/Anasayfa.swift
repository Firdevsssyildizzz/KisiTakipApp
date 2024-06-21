//
//  ViewController.swift
//  KisiTakip
//
//  Created by Macbook on 15/05/2024.
//

import UIKit
import Combine

class Anasayfa: UIViewController {
    @IBOutlet weak var kullaniciAdi: UITextField!
    @IBOutlet weak var sifre: UITextField!
    @IBOutlet weak var buttonUyeol: UIButton!
    @IBOutlet weak var buttonGirisyap: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var viewModel = KayitViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    private func setupBindings() {
        // Kullanıcı adı ve şifre alanlarını ViewModel'e bağlayın
        kullaniciAdi.textPublisher2
            .receive(on: RunLoop.main)
            .assign(to: \.username, on: viewModel)
            .store(in: &cancellables)

        sifre.textPublisher2
            .receive(on: RunLoop.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)

        // Hata mesajını gözlemleyin
        viewModel.$errorMessage
            .sink { [weak self] errorMessage in
                self?.errorLabel.text = errorMessage
            }
            .store(in: &cancellables)

        // Başarı durumunu gözlemleyin
        viewModel.$signInSuccess
                   .sink { [weak self] success in
                       if success {
                           self?.performSegue(withIdentifier: "toPersonListSegue", sender: self)
                       }
                   }
                   .store(in: &cancellables)
    }
    @IBAction func buttonUyeolTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toRegisterSegue", sender: nil)
    }
    
    @IBAction func buttonGirisyapTapped(_ sender: UIButton) {
        viewModel.signInUser(email: kullaniciAdi.text ?? "", password: sifre.text ?? "")
           }

           private func navigateToHomePage() {
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               if let homeVC = storyboard.instantiateViewController(identifier: "Anasayfa") as? Anasayfa {
                   homeVC.modalPresentationStyle = .fullScreen
                   self.present(homeVC, animated: true, completion: nil)
               }
           }
       }
extension UITextField {
    var textPublisher2: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}

