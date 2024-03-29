//
//  TimerController.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 21/02/24.
//

import Foundation

class TimerController: ObservableObject {
    let publisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let maxValue = 5
    @Published var countDown = 5
    var isRunning = true
}
