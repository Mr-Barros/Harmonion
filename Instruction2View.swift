//
//  Introduction2View.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 23/02/24.
//

import SwiftUI

struct Instruction2View: View {
    @ObservedObject var appRouter: AppRouter
    let proxy: GeometryProxy
    
    @ObservedObject var timer = TimerController()
    
    var screenWidth: CGFloat { proxy.size.width }
    var screenHeight: CGFloat { proxy.size.height }
    
    var body: some View {
        
        VStack {
            ZStack {
                GeometryReader { geo in
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .frame(height: screenHeight * 0.60)
                        .offset(y: screenHeight * 0.07)
                    Image("knight")
                        .resizable()
                        .scaledToFit()
                        .frame(height: screenHeight * 0.175)
                        .position(CGPoint(x: geo.size.width * 0.2,
                                          y: geo.size.height - geo.size.height * 0.1 - screenHeight * 0.08))
                    ZStack(alignment: .bottomTrailing) {
                        Text(
                            "It is easier to sound well when only playing the notes of the same tonality. The keyboard is restricted to the tonality of C minor, which makes your improvisation easier."
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
                            appRouter.router = .instruction3
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
                    .position(CGPoint(x: geo.size.width * 0.5,
                                      y: geo.size.height * 0.5))
                }
                .ignoresSafeArea()
            }
            ZStack(alignment: .leading) {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    HStack {
                        ZStack(alignment: .center) {
                            Image("clock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth * 0.1)
                            Text("\(timer.maxValue)")
                                .foregroundStyle(Color.black)
                                .font(.largeTitle)
                        }
                        .opacity(0)
                        .padding(.leading, screenWidth * 0.1)
                        .padding(.trailing, screenWidth * 0.05)
                        KeyboardView(proxy: proxy,
                                     timer: timer)
                    }
                }
            }
            .frame(height: screenHeight * 0.454)
            .ignoresSafeArea()
        }
    }
}

//#Preview {
//    Introduction2View()
//}
