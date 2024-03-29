//
//  WeaponRoomView.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 31/01/24.
//

import SwiftUI

struct WeaponView: View {
    @ObservedObject var appRouter: AppRouter
    let proxy: GeometryProxy
    var percussion: Int?
    @Binding var accompaniment: Int?
    
    var screenWidth: CGFloat { proxy.size.width }
    var screenHeight: CGFloat { proxy.size.height }
    
    let percussionPlayer = SoundManager()
    let accompanimentPlayer = SoundManager()
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
                            "Now, choose an accompaniment for your soundtrack. The accompaniment is crutial to make the music more interesting, having different sounds being played simultaneously."
                        )
                            .font(.title)
                            .multilineTextAlignment(.leading)
                            .frame(width: 450)
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
                                        percussionPlayer.player?.stop()
                                        accompanimentPlayer.player?.stop()
                                        currentlyPlaying = nil
                                    } else {
                                        let concurrentQueue = DispatchQueue.global(qos: .userInitiated)
                                        concurrentQueue.async {
                                            percussionPlayer.playSound(name: "track\(percussion ?? 1)_preview_percussion", fileExtension: ".mp3")
                                        }
                                        concurrentQueue.async {
                                            accompanimentPlayer.playSound(name: "track\(track)_preview_accompaniment", fileExtension: ".mp3")
                                        }
                                        accompaniment = track
                                        currentlyPlaying = track
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(accompaniment == track ? Color.accentColor : Color("NotSelected"))
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
                                if accompaniment == track {
                                    Text("Selected")
                                        .foregroundStyle(Color.white)
                                        .font(.largeTitle)
                                }
                            }
                        }
                    }
                    Button {
                        if accompaniment != nil {
                            percussionPlayer.playSound(name: "track\(percussion ?? 1)_preview_percussion", fileExtension: ".mp3")
                            percussionPlayer.player?.stop()
                            accompanimentPlayer.playSound(name: "track\(percussion ?? 1)_preview_accompaniment", fileExtension: ".mp3")
                            accompanimentPlayer.player?.stop()
                            
                            appRouter.router = .instruction
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .fill(accompaniment != nil ? Color.accentColor : Color.gray)
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
//    WeaponRoomView()
//}
