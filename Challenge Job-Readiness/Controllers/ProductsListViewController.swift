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
        productsTableView.dataSource = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "products_cell", for: indexPath)
        
        let product = products[indexPath.row]
        // TODO: chage cell text
        //cell.textLabel?.text = product.body.title
        cell.textLabel?.text = product.body.title
        return cell
    }
    
    
}
