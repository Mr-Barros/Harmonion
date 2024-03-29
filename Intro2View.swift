//
//  Intro2View.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 20/02/24.
//

import SwiftUI

struct Intro2View: View {
    @ObservedObject var appRouter: AppRouter
    let proxy: GeometryProxy
    
    var screenWidth: CGFloat { proxy.size.width }
    var screenHeight: CGFloat { proxy.size.height }
    
    var body: some View {
        ZStack {
            Color.cyan.ignoresSafeArea()
            Image("background")
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: screenHeight)
                .ignoresSafeArea()
            HStack {
                Image("knight")
                    .resizable()
                    .scaledToFit()
                    .frame(height: screenHeight * 0.4)
                    .padding(screenWidth * 0.03)
                
                ZStack(alignment: .bottomTrailing) {
                    Text(
                        "However, I cannot face this challenge without epic music to inspire me. Can you help me by composing a soundtrack for my battle?"
                    )
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .frame(width: 500, alignment: .top)
                        .padding(50)
                        .padding(.bottom, 100)
                        .foregroundColor(.white)
                        .background(
                            Color.black
                                .opacity(0.75)
                        )
                        .cornerRadius(50)
                    Button {
                        appRouter.router = .armor
                    } label: {
                        Text("Let's go!")
                            .font(.largeTitle)
                            .padding(.horizontal, 40)
                            .frame(height: 100)
                            .foregroundColor(.white)
                            .background(Color.accentColor)
                            .cornerRadius(50)
                            .padding(30)
                    }
                }
            }
        }
    }
}

//#Preview {
//    Intro2View()
//}
