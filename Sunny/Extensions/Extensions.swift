//
//  StringExtension.swift
//  Sunny
//
//  Created by Nikita Pishchugin on 16.08.2022.
//

import UIKit

// First letter in a sentense is Capital
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    // For localization
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func deletingDuplicateWords() -> String {
        var uniqueWords = [String]()
        let words = self.components(separatedBy: .whitespacesAndNewlines)
        
        for word in words {
            if !uniqueWords.contains(word) {
                uniqueWords.append(word)
            }
        }
        
        let result = uniqueWords.joined(separator: " ")
        return result
    }
}

// MARK: - Int
extension Int {
    
    // Int to Double
    func toDouble() -> Double {
        Double(self)
    }
    
    // Int to String
    func toString() -> String {
        String(self)
    }
}

// MARK: - Double
extension Double {
    
    // Double to Int
    func toInt() -> Int {
        Int(self)
    }
    
    // Double to String
    func toString() -> String {
        String(self)
    }
}

// MARK: - Set
extension Set {
    
    func item(at index: Int) -> Element {
        return self[self.index(startIndex, offsetBy: index)]
    }
}

// MARK: - Array
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var uniqueElements = [Element]()
        for element in self {
            if !uniqueElements.contains(element) {
                uniqueElements.append(element)
            }
        }
        return uniqueElements
    }
}

