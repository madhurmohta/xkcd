//
//  StartButtonView.swift
//  Nafa
//
//  Created by Sanooj on 21/11/2020.
//  Copyright © 2020 com.nafa. All rights reserved.
//

import Foundation
import SwiftUI


struct PulsatingPolygonLargeButton: View {
    
    var body: some View {
        ZStack {
            Image("xkcd", bundle: .main)
                .foregroundColor(Color.white)               
                .overlay(
                    Circle()
                        .stroke(lineWidth: 4)
                        .foregroundColor(Color.red)
                        .modifier(
                            HeartBeatAnimation()
                        ),
                    
                    alignment: .center
                )
        }
        .background(Color.clear)
        .transition(
            .asymmetric(
                insertion: .opacity,
                removal: .scale(
                    scale: 200, anchor: .center
                )
            )
        )
    }
}

struct HeartBeatAnimation: ViewModifier {
    @State private var animationAmount: CGFloat = 1

    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 200, alignment: .center)
            .foregroundColor(.red)
            .scaleEffect(animationAmount)
            .animation(.linear(duration: 0.1).delay(0.4).repeatForever(autoreverses: true), value: animationAmount)
            .onAppear {
                animationAmount = 1.2
            }
    }
}
