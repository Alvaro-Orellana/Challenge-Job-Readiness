//
//  Product.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 16/11/2021.
//

import Foundation

struct TopProducts: Decodable {
    let content: [Product]
}

struct Product: Decodable {
    let id: String
}
