//
//  FloatingMenu.swift
//  xkcd
//
//  Created by Maddiee on 28/12/21.
//
import SwiftUI

struct FloatingMenu: View {

    @State var showMenuItem1 = false
    @Binding var isShowShareSheet: Bool
    
    var body: some View {
        VStack {
            Spacer()
            if showMenuItem1 {
                MenuItem(icon: "square.and.arrow.up.on.square.fill")
                    .onTapGesture {
                        self.isShowShareSheet = true
                    }
            }
            
            Button(action: {
                self.showMenu()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(red: 153/255, green: 102/255, blue: 255/255))
                    .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
            }
        }
    }
    
    func showMenu() {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            withAnimation {
                self.showMenuItem1.toggle()
            }
        })
    }
}

//struct FloatingMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        FloatingMenu()
//    }
//}

struct MenuItem: View {
    
    var icon: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(red: 153/255, green: 102/255, blue: 255/255))
                .frame(width: 55, height: 55)
            Image(systemName: icon)
                .imageScale(.large)
                .foregroundColor(.white)
        }
        .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
        .transition(.move(edge: .trailing))
    }
}
