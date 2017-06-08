//
//  SineWaveClass.swift
//  ResearchApp
//
//  Created by 夏山聡史 on 2017/05/11.
//  Copyright © 2017年 夏山聡史. All rights reserved.
//

import Foundation
import AVFoundation


class SineWaveClass{
    var audioEngine: AVAudioEngine!
    var playerNode: AVAudioPlayerNode!
    var mixerNode: AVAudioMixerNode!
    var pcmBuffer: AVAudioPCMBuffer!
    var audioFormat: AVAudioFormat!
    
    //サンプルレート
    let sampleRate: Float = 44100.0
    //周波数
    var frequency: Float = 0.0
    private var count: Int = 0
    
    init(){
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        audioFormat = playerNode.outputFormat(forBus: 0)
        let length = sampleRate
        pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(sampleRate))
        pcmBuffer.frameLength = UInt32(length)
        audioEngine.attach(playerNode)
        mixerNode = audioEngine.mainMixerNode
        audioEngine.connect(playerNode, to: mixerNode, format: audioFormat)
        do{
            try audioEngine.start()
        }catch let error{
            print(error)
        }
    }
    
    func prepareBuffer() -> AVAudioPCMBuffer{
        
        //print(channels)
        
        //Sin波生成
        //print(Int(mixerNode.outputFormat(forBus: 0).channelCount))
        //for ch in (0..<Int(mixerNode.outputFormat(forBus: 0).channelCount)){
        let samples = pcmBuffer.floatChannelData?[0]
        for n in count..<Int(pcmBuffer.frameCapacity){
            samples?[n] = sinf(Float(2.0 * M_PI) * frequency * Float(n) / Float(audioFormat.sampleRate))
            //    }
        }
        pcmBuffer.frameLength = pcmBuffer.frameCapacity
        
        return pcmBuffer
    }
    
    func scheduleBuffer() {
        let buffer = prepareBuffer()
        //playerNode.scheduleBuffer(buffer, at: nil, options: .interruptsAtLoop, completionHandler: nil)
        playerNode.scheduleBuffer(buffer, at: nil, options: .interruptsAtLoop, completionHandler: {
            if self.playerNode.isPlaying {
                self.scheduleBuffer()
            }
        })
    }
    
    
    func preparePlaying() {
        scheduleBuffer()
        scheduleBuffer()
        scheduleBuffer()
        scheduleBuffer()
    }
}


