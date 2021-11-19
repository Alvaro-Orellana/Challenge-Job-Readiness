//
//  ProductsNetworkManager.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 16/11/2021.
//

import Foundation

struct ProductsNetworkManager {
    let top20ProductsURL =  "https://api.mercadolibre.com/highlights/MLA/category/"
    let authorizationHeader = " Bearer APP_USR-7814835816886199-111917-c1d3e84bbcf3f28a795c4270659b1e59-362268385"
    
    
    // Make sure attributes parameters match with model of Item
    let multiGetURL = "https://api.mercadolibre.com/items?attributes=id,title,price,currency_id,sold_quantity,secure_thumbnail,accepts_mercadopago,warranty,pictures&ids="

    
    // Returns an array of only the IDs of the products the given category
    func getMostSoldProductsIDs(of categoryId: String) async throws -> [String] {
        let url = URL(string: top20ProductsURL + categoryId)!
        
        // Create and configure the request
        var request = URLRequest(url: url)
        request.addValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        // Network call
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode received data
        let mostSoldProducts = try decodeProducts(from: data)
        
        // Return an array of only the products' ID's
        return mostSoldProducts.map{ $0.id }
    }
   
    
    // Decodes to array of objets that only contain a string ID
    private func decodeProducts(from data: Data) throws -> [Product] {
        let decoder = JSONDecoder()
        let topProducts = try decoder.decode(TopProducts.self, from: data)
        return topProducts.content
    }
    
    
    func getProducts(productsIDs: [String]) async -> [Item] {
        var items: [Item] = []
        
        do {
            // URL using all the products passed from parameter
            let testURL = createURL(using: productsIDs)
            
            // Network call
            let (data, _ ) = try await URLSession.shared.data(from: testURL)
            
            // Returns array of model objects that only have status code and ID
            let testitems = try decodeTestItems(from: data)
            
            // Gets the IDs of only the items with correct status code
            let correctIDs = testitems
                                    .filter{ $0.code == 200}
                                    .map{ $0.body.id }
                                
            // URL using only products that have 200 status code
            let urlOfIDsWithCorrectStatusCode = createURL(using: correctIDs)
            
            // Network call
            let (itemsObjectData, _ ) = try await URLSession.shared.data(from: urlOfIDsWithCorrectStatusCode)
            
            items = try decodeItems(from: itemsObjectData)
            return items
            
        } catch {
            print(error)
        }
        
        return items
    }

    
    // MARK: Helper methods
    
    private func createURL(using productsID: [String]) -> URL {
        // Base url + products IDs separated by commas
        let endpoint = multiGetURL + productsID.joined(separator: ",")
        return URL(string: endpoint)!
    }
    
    
    // Decodes array of model objects containing only ID and status code
    private func decodeTestItems(from data: Data) throws -> [TestItem] {
        let decoder = JSONDecoder()
        let testItems = try decoder.decode([TestItem].self, from: data)
        return testItems
    }
    
    
    // Decodes the actual product that contains the useful attributes
    private func decodeItems(from data: Data) throws -> [Item] {
        let decoder = JSONDecoder()
        let items = try decoder.decode([Item].self, from: data)
        return items
    }
    
    
    
    
   
}
