//
//  KeyboardView.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 31/01/24.
//

import SwiftUI

extension MidiTone {
    var isBlack: Bool {
        let blackKeys: [UInt8] = [1, 3, 6, 8, 10]
        return blackKeys.contains(self.rawValue % 12)
    }
    var isDbOrEb: Bool {
        return self.rawValue % 12 == 1 || self.rawValue % 12 == 3
    }
    func isWithin(_ keys: [MidiTone]) -> Bool {
        let numbers = keys.map { $0.rawValue % 12 }
        return numbers.contains(self.rawValue % 12)
    }
}

struct KeyboardView: View {
    let proxy: GeometryProxy
    @StateObject var timer: TimerController
    
    var screenWidth: CGFloat { proxy.size.width }
    var screenHeight: CGFloat { proxy.size.height }
    
    let player = FastMidiPlayer(resource: "French_Horn_Section")
    let keyboard: [MidiTone] = [.C3, .Db3, .D3, .Eb3, .E3, .F3, .Gb3, .G3, .Ab3, .A3, .Bb3, .B3, .C4]
    let currentScale: [MidiTone] = [.C3, .D3, .Eb3, .F3, .G3, .Ab3, .Bb3, .C4]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            whiteKeys
            blackKeys
        }
        .padding()
    }
    
    func makeKey(key: MidiTone) -> some View {
        return Button {} label: {
            RoundedRectangle(cornerRadius: 10 * screenHeight / 984)
                .fill(key.isWithin(currentScale)
                      ? key.isBlack ? .black : .white
                      : .gray)
                .frame(width: (key.isBlack ? 74 : 90) * screenHeight / 984,
                       height: (key.isBlack ? 250 : 400) * screenHeight / 984)
                .overlay(
                    RoundedRectangle(cornerRadius: 10 * screenHeight / 984)
                        .stroke(Color.black, lineWidth: 3 * screenHeight / 984)
                )
                .overlay(
                        Circle()
                            .fill(Color.green)
                            .frame(width: 50 * screenHeight / 984,
                                   height: 50 * screenHeight / 984)
                            .padding(25 * screenHeight / 984)
                            .opacity(key.isWithin(currentScale) ? 1 : 0)
                    , alignment: .bottom
            )
        }
        .onLongPressGesture(minimumDuration: 0.01, maximumDistance: 10) {}
            onPressingChanged: { isPressing in
                if isPressing && key.isWithin(currentScale) {
                    player.play(key, duration: 5, withVelocity: 220)
                    timer.countDown = timer.maxValue
                    timer.isRunning = true
                } else {
                    player.stopNote(noteNumber: key.rawValue)
                }
        }
    }
    
    var whiteKeys: some View {
        HStack(spacing: 2 * screenHeight / 984) {
            ForEach(keyboard.filter { !$0.isBlack }, id: \.self) { key in
                makeKey(key: key)
            }
        }
    }
    
    var blackKeys: some View {
        HStack(spacing: 2 * screenHeight / 984) {
            HStack(spacing: 18 * screenHeight / 984) {
                ForEach(keyboard.filter { $0.isBlack && $0.isDbOrEb }, id: \.self) { key in
                    makeKey(key: key)
                }
            }
            .padding(.horizontal, 54 * screenHeight / 984)
            HStack(spacing: 18 * screenHeight / 984) {
                ForEach(keyboard.filter { $0.isBlack && !$0.isDbOrEb }, id: \.self) { key in
                    makeKey(key: key)
                }
            }
            .padding(.horizontal, 54 * screenHeight / 984)
        }
    }
    
}

//#Preview {
//    KeyboardView()
//}
