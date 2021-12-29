//
//  HomeView.swift
//  xkcd
//
//  Created by Maddiee on 28/12/21.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if viewModel.comic.count > 0 {
                    ForEach(viewModel.comic.indices, id: \.self) { index in
                        ComicCard(comic: viewModel.comic[index], onRemove:  { removedComic in
                            self.viewModel.comic.removeAll { $0.id == removedComic.id }
                            if(viewModel.comic.count < 1) {
                                Task.init {
                                    try? await viewModel.fetchComics()
                                }
                            }
                        })
                            .padding(20)
                    }
                } else {
                    PulsatingPolygonLargeButton()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
            .background(Color.blue)
            .onAppear {
                Task.init {
                    try? await viewModel.fetchComics()
                }
            }
    }
            
    
//    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
//        let offset: CGFloat = CGFloat(viewModel.comic.count - 1 - id) * 10
//        return geometry.size.width - offset
//    }
//
//    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
//        return  CGFloat(viewModel.comic.count - 1 - id) * 10
//    }
}

struct DateView: View {
    var body: some View {
      // Container to add background and corner radius to
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(Date.now, format: .dateTime.day().month().year())
                        .font(.title)
                        .bold()
                    Text("Today")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }.padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
