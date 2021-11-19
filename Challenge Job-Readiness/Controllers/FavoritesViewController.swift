//
//  FavoritesViewController.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 19/11/2021.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var favoritesTableView: UITableView!
    
    // MARK: Instance vars
    var selectedCategory: Category? = Category(category_id: "MLA414035", category_name: "Aromatizadores")
    var networkManager = ProductsNetworkManager()
    var favoriteProducts: [Item] = [] {
        didSet{
            favoritesTableView.reloadData()
        }
    }
    
    
    // MARK: Instance methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        getTopProducts(of: selectedCategory)
    }
    
    private func initialSetup() {
        favoritesTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "products_cell")
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        title = "Favoritos"
        view.backgroundColor = .yellow
    }

    func getTopProducts(of category: Category?)  {
        guard let categoryID = category?.category_id
        else {
            return
        }
        Task(priority: .high) {
            do {
                // Gets only the ID's of the the products of given category
                let productsID = try await networkManager.getMostSoldProductsIDs(of: categoryID)

                // Gets the actual products using the IDs
                favoriteProducts = await networkManager.getProducts(productsIDs: productsID)
                
                if favoriteProducts.isEmpty {
                    Alert.show(on: self, title: "Ningun producto encontrado", message: "Este error es culpa de la API!!")
                }
                
            } catch {
                Alert.show(on: self, title: "Error", message: error.localizedDescription)
                print(error)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}



// MARK: TableView Data Source
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "products_cell", for: indexPath) as! ProductCell
        let product = favoriteProducts[indexPath.row]
        
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
extension FavoritesViewController: UITableViewDelegate {
    // Creates, configures and navigates to ProductDetail VC when row is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        // The body property is where the Actual data is
        let selectedProduct = favoriteProducts[indexPath.row].body
        
        // Create ProductDetail VC and present it
        let productDetailVC = storyboard?.instantiateViewController(withIdentifier: "Product_Detail_VC") as! ProductDetailViewController
       
        productDetailVC.product = selectedProduct
        present(productDetailVC, animated: true)
        //navigationController?.pushViewController(productDetailVC, animated: true)
    }
}
