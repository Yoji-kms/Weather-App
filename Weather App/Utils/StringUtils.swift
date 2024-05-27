//
//  StringUtils.swift
//  Weather App
//
//  Created by Yoji on 02.02.2024.
//

import Foundation

extension String {
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst()
        return firstLetter + remainingLetters
    }
    
    var localized: String {
        let string = NSLocalizedString(self, comment: self)
        return string
    }
}

