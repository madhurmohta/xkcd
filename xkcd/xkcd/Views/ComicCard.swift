//
//  ComicCard.swift
//  xkcd
//
//  Created by Maddiee on 28/12/21.
//

import SwiftUI

struct ComicCard: View {
    
    @StateObject private var model = ComicCardViewModel()
    var comic: Comic
    
    @State private var isShowingInfo = false
    @State private var translation: CGSize = .zero
    @State private var angle: Double = 0
    @State private var isShowingSafari = false
    
    private var onRemove: (_ comic: Comic) -> Void
    
    private var thresholdPercentage: CGFloat = 0.5 // when the user has dragged 50% the width of the screen in either

    public init (comic: Comic, onRemove: @escaping (_ comic: Comic) -> Void) {
        self.comic = comic
        self.onRemove = onRemove
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                //    if(!transition) {
                ZStack(alignment: .bottom) {
                    AsyncImage(url: URL(string: comic.img)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(comic.title)
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text(comic.transcript)
                                .font(.body)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            Text("\(comic.id)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        Button(action: {
                            self.isShowingInfo = true
                        }) {
                            Image(systemName: "info.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                }
                .fullScreenCover(isPresented: $isShowingInfo) {
                    InfoView(comic: comic, isOpen: self.$isShowingInfo, isFavourite: model.isFavorite(for: Int(comic.id)))
                        .ignoresSafeArea()
                }
                .background(Color.pink)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 2)
                )
                .shadow(radius: 2)
                .offset(x: self.translation.width, y: self.translation.height)
                .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25.0), anchor: .bottom)
                .animation(.spring(), value: self.angle)
                .cornerRadius(10)
                
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.translation = value.translation
                            self.angle = Double(self.translation.width / geometry.size.width) * 25.0
                            let direction = Utility.detectDirection(value: value)
                            if direction == .up {
                                DispatchQueue.main.async {
                                    model.isFavorite(for: Int(comic.id))
                                }
                            }
                        }
                        .onEnded { value in
                            let gesturePercentage = self.getGesturePercentage(geometry, from: value)
                            if abs(gesturePercentage) > self.thresholdPercentage {
                                if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                                    self.onRemove(self.comic)
                                } else {
                                    self.translation = .zero
                                }
                            } else {
                                self.translation = .zero
                            }
                        }
                )
            }
        }
}
    
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
}

//struct ComicCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ComicCard()
//    }
//}
