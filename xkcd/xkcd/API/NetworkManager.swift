//
//  NetworkManager.swift
//  xkcd
//
//  Created by Maddiee on 28/12/21.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()    
    
    // MARK: - Getting image data for saving in the database
    func getImageData(_ url: String) -> Data {
        guard let url = URL(string: url) else { return Data() }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print(error.localizedDescription)
        }
        
        return Data()
    }
}
