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
    //@IBOutlet weak var noFavoritesView: UITableView!
    
    
    // MARK: Instance vars
    let networkManager = ProductsNetworkManager()
    let persistenceManager = PersistenceManager()
    var favoriteProducts: [Item] = [] {
        didSet{
            favoritesTableView.reloadData()
        }
    }
    
    
    // MARK: Instance methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        //noFavoritesView.backgroundColor = .red
    }
    
    private func initialSetup() {
        favoritesTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "products_cell")
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        title = "Favoritos"
        view.backgroundColor = .yellow
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        getFavoritesProducts()
    }
    
    private func getFavoritesProducts()  {
        
        Task(priority: .high) {
            
            let savedFavorites = persistenceManager.getFavoriteProducts()
            if savedFavorites.isEmpty {
                // Clean table view, otherwise shows the previous saved products
                favoriteProducts = []
                
                //noFavoritesView.isHidden = false
                //favoritesTableView.isHidden = true
                Alert.show(on: self, title: "Ningun producto encontrado", message: "Todavia no has agregado favoritos")
                return
            }
            
            // Found favorites saved
            //noFavoritesView.isHidden = true
            //favoritesTableView.isHidden = false
            
            favoriteProducts = await networkManager.getProducts(productsIDs: savedFavorites)
            
            
            
        }
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
