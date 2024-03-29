//
//  BattleView.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 31/01/24.
//

import SwiftUI
import SpriteKit

var game: GameScene?

struct BattleView: View {
    @ObservedObject var appRouter: AppRouter
    let proxy: GeometryProxy
    var percussion: Int?
    var accompaniment: Int?
    
    let percussionPlayer = SoundManager()
    let accompanimentPlayer = SoundManager()
    @ObservedObject var timer = TimerController()
    
    var screenWidth: CGFloat { proxy.size.width }
    var screenHeight: CGFloat { proxy.size.height }
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                GeometryReader { proxy in
                    SpriteView(scene: scene(size: proxy.size))
                }
                .ignoresSafeArea()
                
                HStack {
                    ZStack(alignment: .center) {
                        Image("clock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.1)
                        Text("\(timer.countDown)")
                            .foregroundStyle(Color.black)
                            .font(.largeTitle)
                    }
                    .padding(.leading, screenWidth * 0.1)
                    .padding(.trailing, screenWidth * 0.05)
                    KeyboardView(proxy: proxy,
                                 timer: timer)
                }
            }
        }
        .onAppear {
            let concurrentQueue = DispatchQueue.global(qos: .userInitiated)
            concurrentQueue.async {
                percussionPlayer.playSound(name: "track\(percussion ?? 1)_percussion", fileExtension: ".mp3")
            }
            concurrentQueue.async {
                accompanimentPlayer.playSound(name: "track\(accompaniment ?? 1)_accompaniment", fileExtension: ".mp3")
            }
        }
        .onReceive(timer.publisher) { _ in
            if timer.isRunning {
                timer.countDown -= 1
            }
            if timer.countDown == 0 {
                timer.isRunning = false
            }
        }
    }
    
    func scene(size: CGSize) -> SKScene {
        game = game ?? GameScene(appRouter: appRouter, timer: timer, size: size)
        game?.size = size
        game?.scaleMode = .aspectFit
        game?.anchorPoint = .init(x: 0.5, y: 0.5)
        return game!
    }
    
}

//#Preview {
//    BattleView()
//}
