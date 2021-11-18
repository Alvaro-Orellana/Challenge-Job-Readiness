//
//  NetworkManager.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 14/11/2021.
//

import Foundation

struct CategoriesNetworkManager {
    
    let categoriesPredictionURL = "https://api.mercadolibre.com/sites/MLA/domain_discovery/search"
    
    
    func getCategories(using searchTerm: String, limit: Int = 8) async throws -> [Category] {
        // Format search term for correct use in URL
        let formattedSearchTerm = searchTerm.noAccents().noWhiteSpaces()
        
        // Create the url
        let endpoint = "\(categoriesPredictionURL)?q=\(formattedSearchTerm)&limit=\(limit)"
        let url = URL(string: endpoint)!
        
        // Call to the server
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Decode the data
        let categories = try decodeCategories(from: data)
        return categories
    }
    
    
    private func decodeCategories(from data: Data) throws -> [Category] {
        let decoder = JSONDecoder()
        let categories = try decoder.decode([Category].self, from: data)
        return categories
    }
    
    
    
    
}
