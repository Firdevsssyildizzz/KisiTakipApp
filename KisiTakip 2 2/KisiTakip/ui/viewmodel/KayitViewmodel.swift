//
//  AnasayfaViewmodel.swift
//  KisiTakip
//
//  Created by Macbook on 22/05/2024.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class KayitViewModel: ObservableObject  {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var errorMessage: String?
    @Published var registrationSuccess: Bool = false
    @Published var signInSuccess: Bool = false

    private let db = Firestore.firestore()
    
    func isValidEmail(_ email: String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailPred.evaluate(with: email)
      }

      func registerUser() {
          guard isValidEmail(email) else {
              self.errorMessage = "Geçersiz e-posta adresi"
              return
          }

          Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
              if let error = error {
                  self.errorMessage = error.localizedDescription
                  return
              }
              
              guard let user = authResult?.user else { return }
              let newUser = [
                  "username": self.username,
                  "email": self.email,
                  "phone": self.phone
              ]
              
              self.db.collection("users").document(user.uid).setData(newUser) { error in
                  if let error = error {
                      self.errorMessage = error.localizedDescription
                  } else {
                      self.registrationSuccess = true
                      self.errorMessage = "Kullanıcı başarıyla kaydoldu"
                  }
              }
          }
      }
      
      func signInUser(email: String, password: String) {
          Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
              if let error = error {
                  self.errorMessage = error.localizedDescription
                  return
              }
              
              guard let user = authResult?.user else {
                  self.errorMessage = "Kullanıcı bulunamadı"
                  return
              }

              self.signInSuccess = true
              self.errorMessage = nil
          }
      }
  }
