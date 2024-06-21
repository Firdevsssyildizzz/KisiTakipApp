//
//  KisiEkleViewmodel.swift
//  KisiTakip
//
//  Created by Macbook on 22/05/2024.
//

import Foundation
import FirebaseFirestore

class KisiEkleViewModel {
    func addKisi(kisiAdSoyad: String, kisiTel: String, latitude: Double, longitude: Double, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").addDocument(data: [
            "kisiAdSoyad": kisiAdSoyad,
            "kisiTel": kisiTel,
            "latitude": latitude,
            "longitude": longitude
        ]) { error in
            completion(error)
        }
    }
}

