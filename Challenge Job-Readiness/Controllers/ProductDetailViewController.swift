//
//  ProductDetailViewController.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 17/11/2021.
//

import UIKit
 

class ProductDetailViewController: UIViewController {

    typealias FinalProduct = Body
    
    @IBOutlet weak var soldItemsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var acceptsMercadoPagoLabel: UILabel!
    @IBOutlet weak var warrantyLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var butWithMercadoPagoButton: UIButton!
    
    var product: FinalProduct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyButton.layer.borderWidth = 0.8
        buyButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 230.0, alpha: 1.0).cgColor

        soldItemsLabel.text = "\(product.sold_quantity) Vendidos"
        titleLabel.text = product.title
        priceLabel.text = "$ \(Int(product.price))"
        acceptsMercadoPagoLabel.isHidden = !product.accepts_mercadopago
        warrantyLabel.text = product.warranty
        
        butWithMercadoPagoButton.isHidden = !product.accepts_mercadopago
        loadImage()
    }
    
    func loadImage() {
        if let url = URL(string: product.secure_thumbnail) {
            Task(priority: .high) {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    
                    productImage.image = UIImage(data: data)
                    
                } catch {
                    print(error.localizedDescription)
                    productImage.image = UIImage(systemName: "questionmark.circle")
                }
            }
        } else {
            productImage.image = UIImage(systemName: "questionmark.circle")
        }
    }
    

    @IBAction func buuButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func buyWithMercadoPagoButtonPressed(_ sender: UIButton) {
    }
    
}
