//
//  PersistenceManager.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 19/11/2021.
//

import Foundation


struct PersistenceManager {
    let favoritesProductsKey = "favorites"
    let userDefaults = UserDefaults.standard

    
    func getFavoriteProducts() -> [String] {
        return userDefaults.object(forKey: favoritesProductsKey) as? [String] ?? []
    }
    
    func isFavorite(productID: String) -> Bool {
        let favoriteProducts = getFavoriteProducts()
        return favoriteProducts.contains(productID)
    }
    
    func saveToFavorites(productID: String) {
        var favoriteProducts = getFavoriteProducts()
        
        // Add ID to array only if it is not already saved
        if !favoriteProducts.contains(productID) {
            favoriteProducts += [productID]

        }
        // Save array to userdafaults
        userDefaults.set(favoriteProducts, forKey: favoritesProductsKey)
    }
    
    
    func removeFromFavorites(productID: String) {
        var favoriteProducts = getFavoriteProducts()

        if let index = favoriteProducts.firstIndex(of: productID) {
            favoriteProducts.remove(at: index)
            userDefaults.set(favoriteProducts, forKey: favoritesProductsKey)
        }
    }
}
