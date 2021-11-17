//
//  ProductsNetworkManager.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 16/11/2021.
//

import Foundation

struct ProductsNetworkManager {
    let top20ProductsURL =  "https://api.mercadolibre.com/highlights/MLA/category/"
    
    let authorizationHeader = "Bearer APP_USR-7814835816886199-111713-f4dd4e6066a0cb111756a547bb2e7093-362268385"
    let multiGetURL = "https://api.mercadolibre.com/items?ids="
    
    
    // Returns an array of the IDs of the products the given category
    func getMostSoldProductsIDs(of categoryId: String) async throws -> [String] {
        let url = URL(string: top20ProductsURL + categoryId)!
        
        // Create and configure the request
        var request = URLRequest(url: url)
        request.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        // Network call
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode data 
        let mostSoldProducts = try decodeProducts(from: data)
        
        // Return an array of only the products' ID's
        return mostSoldProducts.map { $0.id }
    }
   
    
    private func decodeProducts(from data: Data) throws -> [Product] {
        let decoder = JSONDecoder()
        let topProducts = try decoder.decode(TopProducts.self, from: data)
        return topProducts.content
    }
    
    
    func getProducts(productsIDs: [String]) async -> [Item] {
        var items: [Item] = []
  
        
        // Make a network call for each ID in productsIDs
        for id in productsIDs {
            // Create URL
            let endpoint = multiGetURL + id
            let url = URL(string: endpoint)!
            
            do {
                // Network call
                let (data, _ ) = try await URLSession.shared.data(from: url)
               
                // Decode single product
                let item = try decodeItem(from: data)
                items.append(item[0])
            
            } catch  {
                print(error.localizedDescription)
            }
        }
        
        return items
//        let endPoint = multiGetURL + productsIds.joined(separator: ",")
//        let url = URL(string: endPoint)!
//
//        // Network call
//        let (data, _) = try await URLSession.shared.data(from: url)
//
//        // Decode data
//        let items = try decodeItems(from: data)
//        return items
    }
    
    
//    private func decodeItems(from data: Data) throws -> [Item] {
//        let decoder = JSONDecoder()
//        let items = try decoder.decode([Item].self, from: data)
//        return items
//    }
    
    private func decodeItem(from data: Data) throws -> [Item] {
        let decoder = JSONDecoder()
        let items = try decoder.decode([Item].self, from: data)
        return items
    }
    
   
}
