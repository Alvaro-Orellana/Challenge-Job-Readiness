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
        initialSetup()
        getTopProducts(of: selectedCategory)
    }
    
    private func initialSetup() {
        productsTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "products_cell")
        productsTableView.dataSource = self
        productsTableView.delegate = self
        title = selectedCategory?.category_name
        //view.backgroundColor = .yellow
    }

    func getTopProducts(of category: Category?)  {
        guard let categoryID = category?.category_id else { return }
        Task {
            do {
                // Gets only the ID's of the the products of given category
                let productsID = try await networkManager.getMostSoldProductsIDs(of: categoryID)

                // Gets the actual products using the IDs
                products = await networkManager.getProducts(productsIDs: productsID)                
                
            } catch {
                Alert.show(on: self, title: "Error", message: error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
    
}


// MARK: TableView Data Source
extension ProductsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "products_cell", for: indexPath) as! ProductCell
        let product = products[indexPath.row]
        
        // The body property is where the Actual data is
        cell.configure(with: product.body)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: Better Height
        return 170
      }
}


// MARK: TableView Delegate
extension ProductsListViewController: UITableViewDelegate {
    // Creates, configures and navigates to ProductDetail VC when row is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        // The body property is where the Actual data is
        let selectedProduct = products[indexPath.row].body
        
        // Create ProductDetail VC and present it
        let productDetailVC = storyboard?.instantiateViewController(withIdentifier: "Product_Detail_VC") as! ProductDetailViewController
       
        productDetailVC.product = selectedProduct
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}
