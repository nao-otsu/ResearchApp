//
//  FFTViewController.swift
//  ResearchApp
//
//  Created by 夏山聡史 on 2017/05/23.
//  Copyright © 2017年 夏山聡史. All rights reserved.
//

import UIKit

class FFTViewController: UIViewController,EZAudioFFTDelegate,EZMicrophoneDelegate {
    
    var fft: EZAudioFFTRolling!
    var microphone: EZMicrophone!
    @IBOutlet var audioPlot: EZAudioPlot!
    @IBOutlet weak var maxFrequencyLabel: UILabel!
    
    private let ViewControllerFFTWindowSize: vDSP_Length = 4096

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session: AVAudioSession = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
        }catch let error {
            print(error)
        }
        
        microphone = EZMicrophone(delegate: self, startsImmediately: true)
        fft = EZAudioFFTRolling(windowSize: ViewControllerFFTWindowSize, sampleRate: Float(microphone.audioStreamBasicDescription().mSampleRate), delegate: self)
        
        microphone.startFetchingAudio()
        
        audioPlot.shouldFill = true
        audioPlot.plotType = EZPlotType.buffer
        audioPlot.shouldCenterYAxis =  false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        fft.computeFFT(withBuffer: buffer[0], withBufferSize: bufferSize)
    }
    
    func fft(_ fft: EZAudioFFT!, updatedWithFFTData fftData: UnsafeMutablePointer<Float>!, bufferSize: vDSP_Length) {
        
        let maxFrequency: Float = fft.maxFrequency
        //print(maxFrequency)
        DispatchQueue.main.async {
            self.maxFrequencyLabel.text = "Frequency:" + String(maxFrequency) + "Hz"
            self.audioPlot.updateBuffer(fftData, withBufferSize: UInt32(bufferSize))
        }
    }


}
