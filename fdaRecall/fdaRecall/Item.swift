//
//  Item.swift
//  fdaRecall
//
//  Created by banie setijoso on 2025-10-10.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
