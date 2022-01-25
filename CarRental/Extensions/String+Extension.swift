//
//  UIStoryBoard+Extension.swift
//  CarRental
//
//   on 23/12/21.
//

import Foundation
import UIKit



extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
