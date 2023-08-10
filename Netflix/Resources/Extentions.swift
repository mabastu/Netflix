//
//  Extentions.swift
//  Netflix
//
//  Created by Mabast on 09/08/2023.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
