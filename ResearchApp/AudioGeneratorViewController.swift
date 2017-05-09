//
//  AudioGeneratorViewController.swift
//  ResearchApp
//
//  Created by 夏山聡史 on 2017/04/27.
//  Copyright © 2017年 夏山聡史. All rights reserved.
//

import UIKit
import AVFoundation

class AudioGeneratorViewController: UIViewController{
    
    // エンジンの生成
    var audioEngine: AVAudioEngine!
    // ソースノードの生成
    var player: AVAudioPlayerNode!
    
    @IBOutlet weak var frequencySlider: UISlider!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frequencyLabel.text = String(frequencySlider.value)
        //self.view.addSubview(frequencyLabel)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //スライダーから値を取得
    @IBAction func SliderGetValue(_ sender: Any) {
        frequencyLabel.text = String(frequencySlider.value)
    }

    func playSineWave() {
        
        audioEngine = AVAudioEngine()
        player = AVAudioPlayerNode()
        // プレイヤーノードからオーディオフォーマットを取得
        let audioFormat = player.outputFormat(forBus: 0)
        // サンプリング周波数: 44.1K Hz
        let sampleRate = Float(audioFormat.sampleRate)
        // フレームの長さ
        let length = 10 * sampleRate
        print("フレームの長さ:\(length)")
        // PCMバッファーを生成
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity:UInt32(length))
        // frameLength を設定することで mDataByteSize が更新される
        buffer.frameLength = UInt32(length)
        // オーディオのチャンネル数
        let channels = Int(audioFormat.channelCount)
        print("チャンネル数:\(channels)")
        for ch in (0..<channels) {
            let samples = buffer.floatChannelData?[ch]
            for n in 0..<Int(buffer.frameLength) {
                samples?[n] = sinf(Float(2.0 * M_PI) * frequencySlider.value * Float(n) / sampleRate)
            }
        }
        
        // オーディオエンジンにプレイヤーをアタッチ
        audioEngine.attach(player)
        let mixer = audioEngine.mainMixerNode
        // プレイヤーノードとミキサーノードを接続
        audioEngine.connect(player, to: mixer, format: audioFormat)
        // 再生の開始を設定
        /*player.scheduleBuffer(buffer) {
            print("Play completed")
        }*/
        
        do {
            // エンジンを開始
            try audioEngine.start()
            // 再生
            player.play()
            player.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        } catch let error {
            print(error)
        }
    }
    @IBAction func PlayButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            playSineWave()
            playButton.setTitle("Stop", for: .normal)
        }else{
            player.stop()
            playButton.setTitle("Play", for: .normal)
        }
    }
}
