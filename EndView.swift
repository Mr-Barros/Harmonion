//
//  EndView.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 31/01/24.
//

import SwiftUI

struct EndView: View {
    @ObservedObject var appRouter: AppRouter
    let proxy: GeometryProxy
    
    var screenWidth: CGFloat { proxy.size.width }
    var screenHeight: CGFloat { proxy.size.height }
    
    @Binding var percussion: Int?
    @Binding var accompaniment: Int?
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: screenHeight)
                .ignoresSafeArea()
            HStack {
                ZStack(alignment: .bottom) {
                    Text("Congratulations! You've defeated the mighty dragon and freed the kingdom of Harmonion, while learning how to make an epic soundtrack. Now, go explore your new skill, and compose new adventures!")
                        .font(.largeTitle)
                        .multilineTextAlignment(.leading)
                        .frame(width: screenWidth * 0.4)
                        .padding(50)
                        .foregroundColor(.white)
                        .background(
                            Color.black
                                .opacity(0.75)
                        )
                        .cornerRadius(50)
//                    Button {
//                        percussion = nil
//                        accompaniment = nil
//                        appRouter.router = .menu
//                    } label: {
//                        Text("Play Again")
//                            .font(.largeTitle)
//                            .padding(.horizontal, 40)
//                            .frame(height: 75)
//                            .foregroundColor(.white)
//                            .background(Color.accentColor)
//                            .cornerRadius(50)
//                            .padding(30)
//                    }
                }
            }
        }
    }
}

//#Preview {
//    EndView()
//}
