//
//  Comic.swift
//  xkcd
//
//  Created by Maddiee on 26/12/21.
//

import Foundation

struct Comic: Codable, Identifiable, Equatable, Hashable {
    
    let id : Int16
    let month : String
    let link : String
    let year : String
    let news : String
    let safe_title : String
    let transcript : String
    let alt : String
    let img : String
    let title : String
    let day : String
    
    
    enum CodingKeys: String, CodingKey {
        case month, link, year, news, safe_title, transcript, alt, img, title, day
        case id = "num"
    }
}
