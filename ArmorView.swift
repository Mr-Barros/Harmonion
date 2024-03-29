//
//  ArmorRoomView.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 31/01/24.
//

import SwiftUI

struct ArmorView: View {
    @ObservedObject var appRouter: AppRouter
    let proxy: GeometryProxy
    @Binding var percussion: Int?
    
    var screenWidth: CGFloat { proxy.size.width }
    var screenHeight: CGFloat { proxy.size.height }
    
    let player = SoundManager()
    @State var currentlyPlaying: Int? = nil
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image("equipment-room")
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: screenHeight)
                .ignoresSafeArea()
            HStack(spacing: screenWidth * 0.08) {
                VStack {
                    Spacer()
                    ZStack {
                        Text(
                            "First, choose a track for the percussion of your soundtrack. The percussion is essential to define the rhythm of your music."
                        )
                            .font(.title)
                            .multilineTextAlignment(.leading)
                            .frame(width: 350)
                            .padding(50)
                            .foregroundColor(.white)
                            .background(
                                Color.black
                                    .opacity(0.75)
                            )
                            .cornerRadius(50)
                    }
                    Image("knight")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.45, height: screenHeight * 0.45)
                        .padding(.horizontal, screenWidth * 0.02)
                        .padding(.vertical, screenHeight * 0.03)
                }
                
                VStack {
                    ForEach([1, 2, 3], id: \.self) { track in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.black)
                                .opacity(0.75)
                                .frame(width: 400, height: 100)
                                .padding()
                            HStack {
                                Button {
                                    if currentlyPlaying == track {
                                        player.player?.stop()
                                        currentlyPlaying = nil
                                    } else {
                                        player.playSound(name: "track\(track)_preview_percussion", fileExtension: ".mp3")
                                        percussion = track
                                        currentlyPlaying = track
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(percussion == track ? Color.accentColor : Color("NotSelected"))
                                            .frame(width: 75, height: 100)
                                            .padding(.horizontal, 50)
                                        if currentlyPlaying == track {
                                            Image("pause")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 35, height: 35)
                                        } else {
                                            Image("play")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 35, height: 35)
                                                .padding(.leading, 6)
                                        }
                                    }
                                }
                                if percussion == track {
                                    Text("Selected")
                                        .foregroundStyle(Color.white)
                                        .font(.largeTitle)
                                }
                            }
                        }
                    }
                    Button {
                        if percussion != nil {
                            player.player = nil
                            appRouter.router = .weapon
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .fill(percussion != nil ? Color.accentColor : Color.gray)
                                .frame(width: 250, height: 75)
                                .padding(25)
                            Text("Next")
                                .font(.largeTitle)
                                .foregroundStyle(Color.white)
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    ArmorRoomView()
//}
