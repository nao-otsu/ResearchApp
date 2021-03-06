//
//  AudioGeneratorViewController.swift
//  ResearchApp
//
//  Created by 夏山聡史 on 2017/04/27.
//  Copyright © 2017年 夏山聡史. All rights reserved.
//

import UIKit
import AVFoundation

class AudioGeneratorViewController: UIViewController,EZAudioFFTDelegate, EZMicrophoneDelegate{

    var sineWave: SineWaveClass!
    
    @IBOutlet weak var frequencySlider: UISlider!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var audioPlotTime: EZAudioPlot!
    @IBOutlet weak var audioPlotFrequency: EZAudioPlot!
    var fft: EZAudioFFTRolling!
    var microphone: EZMicrophone!
    
    private let ViewControllerFFTWindowSize: vDSP_Length = 4096
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVAudioSession.sharedInstance()
        do {
            //下のスピーカーを使ったまま再生録音可能
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
            //スピーカー上
            //try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            //スピーカー下
            //try session.setCategory(AVAudioSessionCategoryAmbient)
            try session.setActive(true)
        }catch let error {
            print(error)
        }
        
        //時間
        audioPlotTime.plotType = EZPlotType.buffer
        
        //周波数
        audioPlotFrequency.plotType = EZPlotType.buffer
        audioPlotFrequency.shouldFill = true
        //audioPlotFrequency.shouldMirror = false
        //audioPlotFrequency.shouldOptimizeForRealtimePlot = false
        audioPlotFrequency.shouldCenterYAxis = true
        
        
        microphone = EZMicrophone(delegate: self, startsImmediately: true)
        fft = EZAudioFFTRolling(windowSize: ViewControllerFFTWindowSize, sampleRate: Float(microphone.audioStreamBasicDescription().mSampleRate), delegate: self)
        
        microphone.startFetchingAudio()
        
        frequencyLabel.text = String(frequencySlider.value)
        sineWave = SineWaveClass()
        sineWave.frequency = frequencySlider.value
        

    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        microphone = EZMicrophone(delegate: self, startsImmediately: true)
        fft = EZAudioFFTRolling(windowSize: ViewControllerFFTWindowSize, sampleRate: Float(microphone.audioStreamBasicDescription().mSampleRate), delegate: self)
        
        microphone.startFetchingAudio()
        
        frequencyLabel.text = String(frequencySlider.value)
        sineWave = SineWaveClass()
        sineWave.frequency = frequencySlider.value
    }*/
    
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
        if sineWave.playerNode.isPlaying{
            sineWave.playerNode.stop()
            playButton.setTitle("Play", for: .normal)
        }else{
            //sineWaveのインスタンス化 1つ目
            sineWave.preparePlaying()
            sineWave.playerNode.play()
            //sineWave.preparePlaying()
            playButton.setTitle("Stop", for: .normal)
        }
    }
    
    func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        fft.computeFFT(withBuffer: buffer[0], withBufferSize: bufferSize)
        DispatchQueue.main.async {
            self.audioPlotTime.updateBuffer(buffer[0], withBufferSize: bufferSize)
        }

    }
    
    func fft(_ fft: EZAudioFFT!, updatedWithFFTData fftData: UnsafeMutablePointer<Float>!, bufferSize: vDSP_Length) {
        DispatchQueue.main.async {
            //print(fft)
            self.audioPlotFrequency.updateBuffer(fftData, withBufferSize: UInt32(bufferSize))
        }
    }
    
    func htons(value: CUnsignedShort) -> CUnsignedShort {
        return (value << 8) + (value >> 8);
    }
}
