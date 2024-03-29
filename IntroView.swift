//
//  IntroView.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 31/01/24.
//

import SwiftUI

struct IntroView: View {
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
                        "Hello adventurer, my name is Sir Cadence Brassblade. The king of Harmonion has sent me on a mission to defeat a terrible dragon that has been haunting the kingdom."
                    )
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .frame(width: 500, alignment: .top)
                        .padding(50)
                        .padding(.bottom, 80)
                        .foregroundColor(.white)
                        .background(
                            Color.black
                                .opacity(0.75)
                        )
                        .cornerRadius(50)
                    Button {
                        appRouter.router = .intro2
                    } label: {
                        Text("Next")
                            .font(.largeTitle)
                            .padding(.horizontal, 40)
                            .frame(height: 75)
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
//    IntroView(appRouter: AppRouter())
//}
