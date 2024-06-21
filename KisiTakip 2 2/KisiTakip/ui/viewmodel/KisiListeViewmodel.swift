//
//  KisiListeViewmodel.swift
//  KisiTakip
//
//  Created by Macbook on 22/05/2024.
//

import Foundation
import FirebaseFirestore

class Kisiler {
    var id:String?
    var kisiAdSoyad:String?
    var kisiTel:String?
    var latitude: Double?
    var longitude: Double?
    init(){
        
    }
    init(id: String, kisiAdSoyad: String, kisiTel: String, latitude: Double, longitude: Double) {
        self.id = id
        self.kisiAdSoyad = kisiAdSoyad
        self.kisiTel = kisiTel
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(document: DocumentSnapshot) {
        let data = document.data()
        self.id = document.documentID
        self.kisiAdSoyad = data?["kisiAdSoyad"] as? String
        self.kisiTel = data?["kisiTel"] as? String
        self.latitude = data?["latitude"] as? Double
        self.longitude = data?["longitude"] as? Double
    }
}

class KisiListeViewModel {
    var kisiler: [Kisiler] = []
    
    func fetchKisiler(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("users").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.kisiler = snapshot?.documents.compactMap { Kisiler(document: $0) } ?? []
                completion()
            }
        }
    }
}
