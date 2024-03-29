//
//  MenuView.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 25/02/24.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var appRouter: AppRouter
    let proxy: GeometryProxy
    
    var screenWidth: CGFloat { proxy.size.width }
    var screenHeight: CGFloat { proxy.size.height }
    
    var body: some View {
        ZStack {
            Color.cyan.ignoresSafeArea()
            Image("menu")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .frame(width: screenWidth, height: screenHeight)
            
            VStack {
                Spacer()
                Button {
                    appRouter.router = .intro
                } label: {
                    Text("Start")
                        .font(.custom("veryLargeTitle", fixedSize: 50))
                        .padding(.horizontal, 75)
                        .frame(height: 130)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(75)
                        .padding(.bottom, screenHeight * 0.05)
                }
                
            }
        }
        Image(systemName: "speaker.wave.3")
            .font(.largeTitle)
            .bold()
            .position(CGPoint(x: screenWidth * 0.07, y: screenHeight * 0.95))
        Image(systemName: "rectangle.landscape.rotate")
            .font(.largeTitle)
            .bold()
            .position(CGPoint(x: screenWidth * 0.92, y: screenHeight * 0.95))
    }
}

//#Preview {
//    MenuView()
//}
