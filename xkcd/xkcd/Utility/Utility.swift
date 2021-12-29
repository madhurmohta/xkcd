//
//  Utility.swift
//  xkcd
//
//  Created by Maddiee on 26/12/21.
//

import Foundation
import SwiftUI

enum SwipeHVDirection: String {
    case left, right, up, down, none
}

class Utility: NSObject {
    
    static func detectDirection(value: DragGesture.Value) -> SwipeHVDirection {
        if value.startLocation.x < value.location.x - 24 {
            return .left
        }
        if value.startLocation.x > value.location.x + 24 {
            return .right
        }
        if value.startLocation.y < value.location.y - 24 {
            return .down
        }
        if value.startLocation.y > value.location.y + 100 {
            return .up
        }
        return .none
    }
}
