//
//  ComicViewModel.swift
//  xkcd
//
//  Created by Maddiee on 28/12/21.
//

import SwiftUI

class ComicCardViewModel: ObservableObject {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Favourite.id, ascending: true)], animation: .default)
    private var favorites: FetchedResults<Favourite>

    func isFavorite(for id: Int) -> Bool {
        for i in favorites {
            guard Int(i.id) != id else { return true }
        }
        return false
    }

}
