//
//  ProductTableViewCell.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 17/11/2021.
//

import UIKit

class ProductCell: UITableViewCell {
    
    typealias CellProduct = Body

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mercadoPagoLabel: UILabel!
    
    
    func configure(with product: CellProduct) {
        titleLabel.text = product.title
        priceLabel.text = "\(Int(product.price)) \(product.currency_id)"
        mercadoPagoLabel.isHidden = !product.accepts_mercadopago
        //mercadoPagoLabel.text = product.accepts_mercadopago ? "Acepta mercado pago!" : ""
        
        Task(priority: .high) {
            do {
                let (data, _) = try await URLSession.shared.data(from: URL(string: product.secure_thumbnail)!)
                
                productImage.image = UIImage(data: data)
                
            } catch {
                print(error.localizedDescription)
                productImage.image = UIImage(systemName: "questionmark.circle")
            }
        }
        

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
