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
    var pcmBuffer: AVAudioPCMBuffer!
    var mixerNode: AVAudioMixerNode!
    
    //周波数
    var frequency: Float
    
    init(frequencyValue: Float){
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        let audioFormat = playerNode.outputFormat(forBus: 0)
        let sampleRate = Float(audioFormat.sampleRate)
        let length = sampleRate
        pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(length))
        pcmBuffer.frameLength = UInt32(length)
        mixerNode = audioEngine.mainMixerNode
        let channels = Int(mixerNode.outputFormat(forBus: 0).channelCount)
        frequency = frequencyValue
        //Sin波生成
        for ch in (0..<channels){
            let samples = pcmBuffer.floatChannelData?[ch]
            for n in 0..<Int(pcmBuffer.frameLength){
                samples?[n] = sinf(Float(2.0 * M_PI) * frequency * Float(n) / sampleRate)
            }
        }
        
        //オーディオエンジンにプレイヤーノードをアタッチ
        audioEngine.attach(playerNode)
        //プレイヤーノードとミキサーノードを接続
        audioEngine.connect(playerNode, to: mixerNode, format: audioFormat)
        
        }
    
    func playSineWave(){
        do {
            try audioEngine.start()
            playerNode.play()
            playerNode.scheduleBuffer(pcmBuffer, at: nil, options: .loops, completionHandler: nil)
            
        }catch let error {
            print(error)
        }
    }
    
    func stopSineWave(){
        playerNode.stop()
    }
    
}
