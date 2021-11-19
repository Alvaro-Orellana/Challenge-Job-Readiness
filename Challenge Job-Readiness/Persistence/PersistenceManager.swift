//
//  PersistenceManager.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 19/11/2021.
//

import Foundation


struct PersistenceManager {
    let favoritesProductsKey = "favorites"

    
    func isFavorite(productID: String) -> Bool {
        let userDefaults = UserDefaults.standard
        let favoriteProducts = userDefaults.object(forKey: favoritesProductsKey) as? [String] ?? []
        return favoriteProducts.contains(productID)
    }
    
    
    func saveToFavorites(productID: String) {
        let userDefaults = UserDefaults.standard

        // Get the saved favorite products
        var favoriteProducts = userDefaults.object(forKey: favoritesProductsKey) as? [String] ?? []
        print("Before: \(favoriteProducts.description)")
        
        // Add ID to array only if it is not already saved
        if !favoriteProducts.contains(productID) {
            favoriteProducts += [productID]

        }
        // Save array to userdafaults
        userDefaults.set(favoriteProducts, forKey: favoritesProductsKey)
        print("After: \(favoriteProducts.description)")
    }
    
    
    func removeFromFavorites(productID: String) {
        let userDefaults = UserDefaults.standard

        // Get the favorites products array
        var favoriteProducts = userDefaults.object(forKey: favoritesProductsKey) as? [String] ?? []
        print("Before: \(favoriteProducts.description)")

        if let index = favoriteProducts.firstIndex(of: productID) {
            favoriteProducts.remove(at: index)
            userDefaults.set(favoriteProducts, forKey: favoritesProductsKey)
            print("After: \(favoriteProducts.description)")
        }
    }
}
