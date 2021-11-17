//
//  Item.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 16/11/2021.
//

import Foundation

struct Item: Codable {
    let code: Int
    let body: Body
}

struct Body: Codable {
    let id: String
    let title: String
    let price: Float
    let currency_id: String
    let sold_quantity: Int
    let secure_thumbnail: String
}
