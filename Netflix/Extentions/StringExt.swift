//
//  StringExt.swift
//  Netflix
//
//  Created by Mabast on 2024-08-05.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
