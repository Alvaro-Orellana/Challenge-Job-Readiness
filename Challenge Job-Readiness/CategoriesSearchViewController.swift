//
//  ViewController.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 14/11/2021.
//

import UIKit

class CategoriesSearchViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    // MARK: Instance vars
    private(set) var categories: [Category] = [] {
        didSet {
            categoriesTableView.reloadData()
        }
    }
    private let networkManager = CategoriesNetworkManager()
    
    
    // MARK: Instance methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        
        view.backgroundColor = .yellow
        searchBar.barTintColor = .yellow
        
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)

        navigationController?.navigationBar.prefersLargeTitles = true

        
    }
    
   
    func getCategories(using searchTerm: String) {
        // Task makes posible to call this function from a synchronous context
        Task {
            do {
                // Network call
                categories = try await networkManager.getCategories(using: searchTerm)
                if categories.isEmpty {
                    Alert.show(on: self, title: "Categoria no encontrada", message: "No encontramos nada asociado con \(searchTerm), prueba con otro nombre")
                }

            } catch {
                print(error.localizedDescription)
                Alert.show(on: self, title: "Ocurrio un error de red", message: "Checkea tu conexion y vuelve a intentar")
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Gets the ProductDetail VC and passes the selected category to it
        guard let productDetailVC = segue.destination as? ProductsListViewController,
              let indexPath = categoriesTableView.indexPathForSelectedRow else {
                  return
              }
        productDetailVC.selectedCategory = categories[indexPath.row]
        
        // Deselect row
        categoriesTableView.deselectRow(at: indexPath, animated: false)
    }
    
}


// MARK: TableView DataSource
extension CategoriesSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categories_cell", for: indexPath)
        
        // Configure cell
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.category_name
        // TODO: Add image to cell
        return cell
    }
    
}


// MARK: SearchBar Delegate
extension CategoriesSearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        // Clean search bar
        searchBar.searchTextField.text = ""
        
        // Clean table view
        categories = []
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        // Capture user input and use it to make network call
        guard let searchTerm = searchBar.searchTextField.text,
              !searchTerm.isEmpty else { return }
        
        getCategories(using: searchTerm)
    }
    
}
