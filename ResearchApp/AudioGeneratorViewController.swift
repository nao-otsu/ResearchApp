//
//  AudioGeneratorViewController.swift
//  ResearchApp
//
//  Created by 夏山聡史 on 2017/04/27.
//  Copyright © 2017年 夏山聡史. All rights reserved.
//

import UIKit
import AVFoundation

class AudioGeneratorViewController: UIViewController,EZMicrophoneDelegate,EZAudioFFTDelegate{
    
    var sineWave: SineWaveClass!
    
    @IBOutlet weak var frequencySlider: UISlider!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frequencyLabel.text = String(frequencySlider.value)
        sineWave = SineWaveClass()
        sineWave.frequency = frequencySlider.value
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //スライダーから値を取得
    @IBAction func SliderGetValue(_ sender: Any) {
        //ラベルの値更新
        frequencyLabel.text = String(frequencySlider.value)
        sineWave.frequency = frequencySlider.value
        
    }

    @IBAction func PlayButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            //sineWaveのインスタンス化 1つ目
            playButton.setTitle("Stop", for: .normal)
            sineWave.preparePlaying()
            sineWave.playerNode.play()
            //sineWave.preparePlaying()
        }else if sender.titleLabel?.text == "Stop"{
            playButton.setTitle("Play", for: .normal)
            if sineWave.playerNode.isPlaying{
                sineWave.playerNode.stop()
            }
        }
    }
    
        
    
}
