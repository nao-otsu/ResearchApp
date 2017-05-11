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
    
    var sineWave1: SineWaveClass!
    var sineWave2: SineWaveClass!
    
    @IBOutlet weak var frequencySlider: UISlider!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ラベルの初期設定
        frequencyLabel.text = String(frequencySlider.value)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //スライダーから値を取得
    @IBAction func SliderGetValue(_ sender: Any) {
        //ラベルの値更新
        frequencyLabel.text = String(frequencySlider.value)
        
        if let _ = sineWave1 {
            //再生中の時
            if sineWave1.playerNode.isPlaying || sineWave2.playerNode.isPlaying {
                checkSineWave()
            }
        }
        
    }

    @IBAction func PlayButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            //sineWaveのインスタンス化 1つ目
            sineWave1 = SineWaveClass(frequencyValue: frequencySlider.value)
            playButton.setTitle("Stop", for: .normal)
            if let sineWave = sineWave1{
                sineWave.playSineWave()
            }
        }else{
            playButton.setTitle("Play", for: .normal)
            if sineWave1.playerNode.isPlaying{
                sineWave1.stopSineWave()
            } else {
                sineWave2.stopSineWave()
            }
        }
    }
    

    func checkSineWave(){
        if sineWave1.playerNode.isPlaying {
            sineWave2 = SineWaveClass(frequencyValue: frequencySlider.value)
            sineWave1.stopSineWave()
            sineWave2.playSineWave()
            
        }else if sineWave2.playerNode.isPlaying{
            sineWave1 = SineWaveClass(frequencyValue: frequencySlider.value)
            sineWave2.stopSineWave()
            sineWave1.playSineWave()
            
        }
    }
}
