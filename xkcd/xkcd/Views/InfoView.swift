//
//  MatchedView.swift
//  xkcd
//
//  Created by Maddiee on 28/12/21.
//

import SwiftUI

struct InfoView: View {

    var comic: Comic
    @Binding var isOpen: Bool
    @State private var isShowingShareSheet = false
    private let network = NetworkManager.shared
    @State var isFavourite: Bool
    @Environment(\.managedObjectContext) private var viewContext


    var body: some View {
        GeometryReader { geometry in
            
            NavigationView {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView{
                        VStack(alignment: .leading, spacing: 20) {
                            
                            AsyncImage(url: URL(string: comic.img)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width, height: 300, alignment: .center)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Section("Transcript"){
                                Text(comic.transcript)
                            }
                            .padding(.leading, 20)
                            
                            Section("Published On"){
                                Text(" \(comic.day) - \(comic.month) - \(comic.year)")
                            }
                            .padding(.leading, 20)
                        }
                    }
                    FloatingMenu(isShowShareSheet: self.$isShowingShareSheet)
                        .padding()
                }
                .navigationTitle(comic.title)
                .navigationBarItems(
                    leading:
                        Button("Close") {
                            isOpen = false
                        }, trailing: Button(action: {
                            if !isFavourite {
                                save(comic: comic)
                            }
                         }) {
                             Image(systemName: self.isFavourite ? "star.fill" : "star")
                                   .resizable()
                         }
                    
                )
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .sheet(isPresented: $isShowingShareSheet) {
                let imageURL = comic.img
                ShareSheet(activityItems: [UIImage(data: network.getImageData(imageURL)) ?? UIImage(), comic.title, comic.alt])
            }
        }
    }
    
    private func save(comic: Comic) {
        withAnimation {
            let newComic = Favourite(context: viewContext)
            newComic.id =  Int16(comic.id)
            newComic.link = comic.link
            newComic.year = comic.year
            newComic.news = comic.news
            newComic.transcript = comic.transcript
            newComic.alt = comic.alt
            newComic.img = comic.transcript
            newComic.title = comic.title
            newComic.day = comic.day
            newComic.month = comic.month


            do {
                try viewContext.save()
                isFavourite.toggle()
            } catch {
                // This error should handle for the application release.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//struct MatchedView_Previews: PreviewProvider {
//    static var previews: some View {
//        InfoView()
//    }
//}
