//
//  String + noAccents.swift
//  Challenge Job-Readiness
//
//  Created by Alvaro Hernan Orellana Villarroel on 15/11/2021.
//

import Foundation


extension String {

    func noAccents() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }

    func noWhiteSpaces() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
