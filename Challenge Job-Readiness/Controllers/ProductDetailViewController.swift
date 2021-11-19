//
//  ProductDetailViewController.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 17/11/2021.
//

import UIKit
 

class ProductDetailViewController: UIViewController {

    typealias FinalProduct = Body
    
    @IBOutlet weak var cointainerScrollView: UIScrollView!
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
        //navigationController?.navigationBar.backgroundColor = .yellow
        view.backgroundColor = .yellow
        cointainerScrollView.backgroundColor = .white
        configureFavoritesBarButton()
        configureLabels()
        loadImage()
    }
    
    private func configureFavoritesBarButton() {
        let favoritesButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoritesButtonPressed))
        navigationItem.rightBarButtonItem = favoritesButton
    }
    
    private func configureLabels() {
        soldItemsLabel.text = "\(product.sold_quantity) Vendidos"
        titleLabel.text = product.title
        priceLabel.text = "$ \(Int(product.price))"
        acceptsMercadoPagoLabel.isHidden = !product.accepts_mercadopago
        warrantyLabel.text = product.warranty
        butWithMercadoPagoButton.isHidden = !product.accepts_mercadopago
    }
    
    
    private func loadImage() {
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
    
    @objc func favoritesButtonPressed() {
        print("Favorite added")
    }
    

    @IBAction func buyWithMercadoPagoButtonPressed(_ sender: UIButton) {
        print("buy with MP pressed")
    }
    
    @IBAction func buuButtonPressed(_ sender: UIButton) {
        print("normal buy pressed")
 }
    
    
    
}
