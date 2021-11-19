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
    
    var isFavorite = false {
        didSet {
            updateFavoritesButton()
            
            if isFavorite {
                persistenceManager.saveToFavorites(productID: product.id)
            } else {
                persistenceManager.removeFromFavorites(productID: product.id)
            }
        }
    }
    var product: FinalProduct!
    let persistenceManager = PersistenceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Some UI setup
        buyButton.layer.borderWidth = 0.8
        buyButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 230.0, alpha: 1.0).cgColor
        view.backgroundColor = .yellow
        cointainerScrollView.backgroundColor = .white
        
        // Fills the views with the corresponding data
        loadProductImage()
        configureLabels()
    }
    
    
    private func configureLabels() {
        soldItemsLabel.text = "\(product.sold_quantity) Vendidos"
        titleLabel.text = product.title
        priceLabel.text = "$ \(Int(product.price))"
        acceptsMercadoPagoLabel.isHidden = !product.accepts_mercadopago
        warrantyLabel.text = product.warranty
        butWithMercadoPagoButton.isHidden = !product.accepts_mercadopago
    }
    
    
    private func loadProductImage() {
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFavorite = persistenceManager.isFavorite(productID: product.id)
    }
    
    private func updateFavoritesButton() {
        let heartImage = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        let favoritesButton = UIBarButtonItem(image: heartImage, style: .plain, target: self, action: #selector(favoritesButtonPressed))
        navigationItem.rightBarButtonItem = favoritesButton
    }

    
    @objc func favoritesButtonPressed() {
        isFavorite.toggle()
    }
    
    
    
    // MARK: Actions
    @IBAction func buyWithMercadoPagoButtonPressed(_ sender: UIButton) {
        print("buy with MP pressed")
    }
    
    @IBAction func buuButtonPressed(_ sender: UIButton) {
        print("normal buy pressed")
 }
    
    
    
}
