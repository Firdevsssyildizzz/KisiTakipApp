//
//  ViewController.swift
//  KisiTakip
//
//  Created by Macbook on 22/05/2024.
//

import UIKit

class KisiListe: UIViewController {

    @IBOutlet weak var kisiListeTable: UITableView!
    
    var kisilerListesiViewModel = KisiListeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        kisiListeTable.delegate = self
        kisiListeTable.dataSource = self
        
        // Firebase'den verilerin çekilmesi
        kisilerListesiViewModel.fetchKisiler {
            // Veriler çekildikten sonra TableView'i güncelle
            self.kisiListeTable.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toKisiDetay" {
            if let detailVC = segue.destination as? KisiDetay,
               let kisi = sender as? Kisiler {
                detailVC.kisi = kisi
            }
        }
    }
}

extension KisiListe: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kisilerListesiViewModel.kisiler.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kisi = kisilerListesiViewModel.kisiler[indexPath.row]
        let hucre = tableView.dequeueReusableCell(withIdentifier: "kisilerHucre") as! KisilerHucre
        hucre.configure(with: kisi)
        hucre.detayButonHandler = {
            self.performSegue(withIdentifier: "toKisiDetay", sender: kisi)
        }
        return hucre
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
