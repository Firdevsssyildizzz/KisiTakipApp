//
//  ViewController.swift
//  KisiTakip
//
//  Created by Macbook on 22/05/2024.
//

import UIKit
import MapKit
import CoreLocation

class KisiDetay: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var labelKisiBilgi: UILabel!
    
    
    var kisi: Kisiler? {
        didSet {
            if let kisii = kisi {
                print("kisi atandı: \(kisii.kisiAdSoyad ?? "Bilinmiyor")")
                kisiDetayViewModel = KisiDetayViewModel(kisii: kisii)
            } else {
                print("kisi nil, kisiDetayViewModel oluşturulamadı")
            }
        }
    }
    
    var kisiDetayViewModel: KisiDetayViewModel?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CLLocationManager delegate'i ayarla
        locationManager.delegate = self
        
        // Kullanıcıdan konum izni iste
        locationManager.requestWhenInUseAuthorization()
        
        // Debug log ekleyelim
                print("viewDidLoad çağrıldı")
        
        // Kişi bilgisi güncelleniyor
        if let kisii = kisi {
            print("viewDidLoad'da kisi bulundu: \(kisii.kisiAdSoyad ?? "Bilinmiyor")")
            updateKisiBilgisi()
            setupMapView(with: kisii)
        } else {
            print("viewDidLoad'da kisi bulunamadı")
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear çağrıldı")
        if let kisii = kisi {
            print("viewWillAppear'de kisi bulundu: \(kisii.kisiAdSoyad ?? "Bilinmiyor")")
            updateKisiBilgisi()
            setupMapView(with: kisii)
        } else {
            print("Kisi bilgisi viewWillAppear içinde bulunamadı")
        }
    }
    
    func updateKisiBilgisi() {
        if let kisiDetayViewModel = kisiDetayViewModel {
            print("Kişi bilgisi güncelleniyor: \(kisiDetayViewModel.kisiAdSoyad ?? "Bilinmiyor")")
            labelKisiBilgi.text = kisiDetayViewModel.kisiAdSoyad ?? "Bilinmiyor"
        } else {
            print("Kişi bilgisi güncellenemedi çünkü kisiDetayViewModel bulunamadı")
        }
    }
    
    func setupMapView(with kisii: Kisiler) {
        guard let latitude = kisii.latitude, let longitude = kisii.longitude else { return }
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = kisii.kisiAdSoyad
        mapView.addAnnotation(annotation)
    }

    // CLLocationManagerDelegate metodları
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = kisi?.kisiAdSoyad
            mapView.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            let alert = UIAlertController(title: "Konum İzni Gerekli", message: "Konum servisi kullanmak için izninize ihtiyacımız var. Lütfen ayarlardan izin verin.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
}
