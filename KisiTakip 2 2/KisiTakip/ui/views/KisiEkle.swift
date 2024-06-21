//
//  ViewController.swift
//  KisiTakip
//
//  Created by Macbook on 22/05/2024.
//

import UIKit
import CoreLocation

class KisiEkle: UIViewController, CLLocationManagerDelegate {


    @IBOutlet weak var adSoyadTextfield: UITextField!
    
    @IBOutlet weak var telefonTextfield: UITextField!
    
    @IBOutlet weak var konumEkleButton: UIButton!
    
    @IBOutlet weak var kaydetButton: UIButton!
    
    var locationManager: CLLocationManager!
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Konum izni için CLLocationManager başlat
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // CLLocationManagerDelegate ile ilgili işlemler
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        print("Konum güncellendi: Latitude: \(latitude!), Longitude: \(longitude!)")
    }

    // Konum Ekle butonuna tıklama işlemi
    
    @IBAction func konumEkleButtonTapped(_ sender: UIButton) {
        // Konum izni yoksa kullanıcıya iste
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        // Konum bilgisini güncelle
        locationManager.startUpdatingLocation()
    }

    @IBAction func kaydetButtonTapped(_ sender: UIButton) {
        guard let adSoyad = adSoyadTextfield.text, !adSoyad.isEmpty,
              let telefon = telefonTextfield.text, !telefon.isEmpty,
              let latitude = latitude,
              let longitude = longitude else {
            // Gerekli bilgiler eksik, kullanıcıya uyarı göster
            return
    }
        // Kişiyi Firebase'e ekle
        let viewModel = KisiEkleViewModel()
        viewModel.addKisi(kisiAdSoyad: adSoyad, kisiTel: telefon, latitude: latitude, longitude: longitude) { error in
                    if let error = error {
                // Hata varsa kullanıcıya uyarı göster
                print("Error adding document: \(error)")
            } else {
                // Başarılı mesajı kullanıcıya göster
                print("Kişi başarıyla eklendi!")
            }
        }
    }
}
