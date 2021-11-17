//
//  ProductDetailViewController.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 15/11/2021.
//

import UIKit

class ProductsListViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var productsTableView: UITableView!
    
    // MARK: Instance vars
    var selectedCategory: Category?
    var networkManager = ProductsNetworkManager()
    var products: [Item] = [] {
        didSet{
            productsTableView.reloadData()
        }
    }
    
    // MARK: Instance methods
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "products_cell")
        productsTableView.dataSource = self
        productsTableView.delegate = self
        title = selectedCategory?.category_name
        view.backgroundColor = .yellow
        getTopProducts(of: selectedCategory)
    }
    

    func getTopProducts(of category: Category?)  {
        guard let categoryID = category?.category_id else {return}
        
        Task {
            do {
                // Gets only the ID's of the the products of given category
                let productsID = try await networkManager.getMostSoldProductsIDs(of: categoryID)

                // Gets the actual products
                products = await networkManager.getProducts(productsIDs: productsID)                
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
  
    
    // Sets up navigation to ProductDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("SE LLAMO PREPARE FOR SEGUE")
        // Gets the ProductDetail VC and passes the selected product to it
        guard let productDetailVC = segue.destination as? ProductDetailViewController,
              let indexPath = productsTableView.indexPathForSelectedRow else {
                  return
              }
        
        // The property body is where the Actual data is
        let selectedProduct = products[indexPath.row].body
        productDetailVC.selectedProduct = selectedProduct

    }

}

// MARK: TableView Data Source
extension ProductsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "products_cell", for: indexPath) as! ProductCell
        //let cell = Bundle.main.loadNibNamed("CellXib", owner: self, options: nil)?.first as! ProductCell

        
        let product = products[indexPath.row]
        
        cell.titleLabel.text = product.body.title
        cell.priceLabel.text = "\(product.body.price) \(product.body.currency_id)"
        cell.mercadoPagoLabel.text = product.body.accepts_mercadopago ? "Acepta mercado pago!" : ""
        cell.productImage.image = UIImage(named: "auto_rojo")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130 //give height you want
      }
}

extension ProductsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SE LLAMO DID SELECT ROW AT")
         let productDetailVC = ProductDetailViewController()
        
        
        // The property body is where the Actual data is
        let selectedProduct = products[indexPath.row].body
        productDetailVC.selectedProduct = selectedProduct
        
        
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}
