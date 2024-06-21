//
//  KisilerHucre.swift
//  KisiTakip
//
//  Created by Macbook on 25/05/2024.
//

import UIKit

class KisilerHucre: UITableViewCell {

    @IBOutlet weak var hucreArkaplan: UIView!
    @IBOutlet weak var labelAdSoyad: UILabel!
    @IBOutlet weak var detayButon: UIButton!
    
    var detayButonHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detayButon.layer.cornerRadius = 5
        detayButon.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with kisi: Kisiler) {
        labelAdSoyad.text = kisi.kisiAdSoyad
    }
    @IBAction func detayButonaTiklandi(_ sender: UIButton) {
        detayButonHandler?()
    }
}
