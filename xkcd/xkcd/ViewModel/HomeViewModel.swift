//
//  HomeViewModel.swift
//  xkcd
//
//  Created by Maddiee on 28/12/21.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    static let shared = HomeViewModel()
    @Published private(set) var state = State()
    @Published var currentComic = 1
    @Published var comic: [Comic] = []
    var tempArray: [Comic] = []
    
    private let store = ComicStore()
    
    public init() { }

    @MainActor
    func fetchComics() async throws {
        print("**** Fetch comics start *****")
        
        for index in currentComic...currentComic + 10 {
            currentComic = index
            let loadedComic = try await store.load(comicType: .current, currentComic: index)
            self.tempArray.append(loadedComic)
        }
        DispatchQueue.main.async {
            self.comic.append(contentsOf: self.tempArray.reversed())
            self.currentComic = self.currentComic + 1
            self.tempArray.removeAll()
        }
    }

    struct State {
        var comics: [Comic] = []
        var isLoading = true
    }
}

private actor ComicStore {
    
    enum ComicType: String {
        case current
        
        func getURL(for type: ComicType, currentComic: Int = 1) -> URL {
            
            var components = URLComponents()
            components.scheme = "https"
            components.host = "xkcd.com"
            
            switch type {
            case .current:
                components.path = "/\(currentComic)/info.0.json"
            }
            
            return components.url!
        }
    }
    
    func load(comicType: ComicType, currentComic: Int = 1) async throws -> Comic {
        let (data, response) = try await URLSession.shared.data(from: comicType.getURL(for: comicType, currentComic: currentComic))
        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw DownloadError.statusNotOk
        }
        guard let decodedResponse = try? JSONDecoder().decode(Comic.self, from: data)
        else { throw DownloadError.decoderError }
        return decodedResponse
    }
}

enum DownloadError: Error {
    case statusNotOk
    case decoderError
}
