//
//  KisiDetayViewmodel.swift
//  KisiTakip
//
//  Created by Macbook on 22/05/2024.
//

import Foundation
import CoreLocation

class KisiDetayViewModel {
    var kisii: Kisiler?
    
    init(kisii: Kisiler?) {
        self.kisii = kisii
    }
    
    var kisiAdSoyad: String? {
        return kisii?.kisiAdSoyad
    }
    
    
    var latitude: Double? {
        return kisii?.latitude
    }
    
    var longitude: Double? {
        return kisii?.longitude
    }
}

