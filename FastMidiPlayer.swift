//
//  FastMidiPlayer.swift
//  Harmonion
//
//  Created by Davi Martignoni Barros on 31/01/24.
//

import Foundation
import AVFoundation

class FastMidiPlayer {
    let sampler: AVAudioUnitSampler
    let engine: AVAudioEngine
    
    init(resource: String, onError: ((Error) -> Void)? = nil) {
        engine = AVAudioEngine()
        sampler = AVAudioUnitSampler()
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        guard let bankURL = Bundle.main.url(forResource: resource, withExtension: "sf2") else {
            onError?(NSError(domain: "com.example.FastMidiPlayer", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load soundfont"]))
            return
        }
        do {
            try sampler.loadInstrument(at: bankURL)
            try engine.start()
        } catch {
            onError?(error)
        }
    }
    
    
    /// Plays a MIDI note with the given note number for a specified duration.
    /// - Parameters:
    ///  - noteNumber: The MIDI note number to be played.
    ///  - duration: The duration for which the note should be played in seconds.
    ///  - withVelocity: The velocity or loudness of the note. Default value is 64.
    ///  - onChanel: The MIDI channel on which the note should be played. Default value is 0.
    func play(_ noteNumber: UInt8, duration: TimeInterval, withVelocity:UInt8 = 64, onChanel:UInt8 = 0) {
        sampler.startNote(noteNumber, withVelocity: withVelocity, onChannel: onChanel)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.stopNote(noteNumber: noteNumber)
        }
    }
    
    
    /// This method plays a MIDI note using the provided parameters.
    /// - Parameters:
    ///  - noteNumber: The MIDI note number to be played, which ranges from 0 to 127. By default, it is set to 69, which is A4.
    ///  - withVelocity: The velocity, which determines how hard the note is played. It ranges from 0 to 127, with 64 being the default value.
    ///  - onChanel: The channel on which the note will be played, which ranges from 0 to 15. The default value is 0.
    func playNote(noteNumber:UInt8 = 69, withVelocity:UInt8=64, onChanel:UInt8=0) {
        sampler.startNote(noteNumber, withVelocity: withVelocity, onChannel: onChanel)
    }
    
    // This method stops the specified MIDI note from playing on the specified channel.
    /// - Parameters:
    ///   - noteNumber: The MIDI note number to be stopped, which ranges from 0 to 127. By default, it is set to 69, which is A4.
    ///   - onChanel: The channel on which the note will be stopped, which ranges from 0 to 15. The default value is 0.
    func stopNote(noteNumber:UInt8 = 69, onChanel:UInt8=0) {
        sampler.stopNote(noteNumber, onChannel: onChanel)
    }
    
    
    /*
     
        < Wrappers to use the MidiTone enum >
     
     */
    
    /// Plays a MIDI note with the given note number for a specified duration.
    /// - Parameters:
    ///  - noteNumber: The MIDI note number to be played.
    ///  - duration: The duration for which the note should be played in seconds.
    ///  - withVelocity: The velocity or loudness of the note. Default value is 64.
    ///  - onChanel: The MIDI channel on which the note should be played. Default value is 0.
    func play(_ noteNumber: MidiTone, duration: TimeInterval, withVelocity:UInt8 = 64, onChanel:UInt8 = 0) {
        sampler.startNote(noteNumber.rawValue, withVelocity: withVelocity, onChannel: onChanel)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.stopNote(noteNumber: noteNumber.rawValue)
        }
    }
    
    /// This method plays a MIDI note using the provided parameters.
    /// - Parameters:
    ///  - noteNumber: The MIDI note number to be played, which ranges from 0 to 127. By default, it is set to 69, which is A4.
    ///  - withVelocity: The velocity, which determines how hard the note is played. It ranges from 0 to 127, with 64 being the default value.
    ///  - onChanel: The channel on which the note will be played, which ranges from 0 to 15. The default value is 0.
    func playNote(_ noteNumber:MidiTone = .A4, withVelocity:UInt8=64, onChanel:UInt8=0) {
        sampler.startNote(noteNumber.rawValue, withVelocity: withVelocity, onChannel: onChanel)
    }
    
    // This method stops the specified MIDI note from playing on the specified channel.
    /// - Parameters:
    ///   - noteNumber: The MIDI note number to be stopped, which ranges from 0 to 127. By default, it is set to 69, which is A4.
    ///   - onChanel: The channel on which the note will be stopped, which ranges from 0 to 15. The default value is 0.
    func stopNote(_ noteNumber:MidiTone = .A4, onChanel:UInt8=0) {
        sampler.stopNote(noteNumber.rawValue, onChannel: onChanel)
    }
    
}

//MARK: Notes in a 88 key piano
enum MidiTone: UInt8 {
    case C0 = 12
    case Db0 = 13
    case D0 = 14
    case Eb0 = 15
    case E0 = 16
    case F0 = 17
    case Gb0 = 18
    case G0 = 19
    case Ab0 = 20
    case A0 = 21
    case Bb0 = 22
    case B0 = 23

    case C1 = 24
    case Db1 = 25
    case D1 = 26
    case Eb1 = 27
    case E1 = 28
    case F1 = 29
    case Gb1 = 30
    case G1 = 31
    case Ab1 = 32
    case A1 = 33
    case Bb1 = 34
    case B1 = 35

    case C2 = 36
    case Db2 = 37
    case D2 = 38
    case Eb2 = 39
    case E2 = 40
    case F2 = 41
    case Gb2 = 42
    case G2 = 43
    case Ab2 = 44
    case A2 = 45
    case Bb2 = 46
    case B2 = 47

    case C3 = 48
    case Db3 = 49
    case D3 = 50
    case Eb3 = 51
    case E3 = 52
    case F3 = 53
    case Gb3 = 54
    case G3 = 55
    case Ab3 = 56
    case A3 = 57
    case Bb3 = 58
    case B3 = 59

    case C4 = 60
    case Db4 = 61
    case D4 = 62
    case Eb4 = 63
    case E4 = 64
    case F4 = 65
    case Gb4 = 66
    case G4 = 67
    case Ab4 = 68
    case A4 = 69
    case Bb4 = 70
    case B4 = 71

    case C5 = 72
    case Db5 = 73
    case D5 = 74
    case Eb5 = 75
    case E5 = 76
    case F5 = 77
    case Gb5 = 78
    case G5 = 79
    case Ab5 = 80
    case A5 = 81
    case Bb5 = 82
    case B5 = 83

    case C6 = 84
    case Db6 = 85
    case D6 = 86
    case Eb6 = 87
    case E6 = 88
    case F6 = 89
    case Gb6 = 90
    case G6 = 91
    case Ab6 = 92
    case A6 = 93
    case Bb6 = 94
    case B6 = 95

    case C7 = 96
    case Db7 = 97
    case D7 = 98
    case Eb7 = 99
    case E7 = 100
    case F7 = 101
    case Gb7 = 102
    case G7 = 103
    case Ab7 = 104
    case A7 = 105
    case Bb7 = 106
    case B7 = 107

    case C8 = 108
    case Db8 = 109
    case D8 = 110
    case Eb8 = 111
    case E8 = 112
    case F8 = 113
    case Gb8 = 114
    case G8 = 115
    case Ab8 = 116
    case A8 = 117
    case Bb8 = 118
    
    case B8 = 119
    case C9 = 120
    case Db9 = 121
    case D9 = 122
    case Eb9 = 123
    case E9 = 124
    case F9 = 125
    case Gb9 = 126
    case G9 = 127
}
