//
//  AudioViewController.swift
//  ResearchApp
//
//  Created by 夏山聡史 on 2017/04/20.
//  Copyright © 2017年 夏山聡史. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var soundRecoder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    var audioSession: AVAudioSession!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //AVAudioRecorderの準備
    func prepareRecoder() {
        
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            
            //初期設定
            let audioSettings = [AVFormatIDKey: kAudioFormatMPEG4AAC,
                                 AVEncoderBitRateKey: 128000,
                                 AVSampleRateKey: 44100,
                                 AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
                                 AVNumberOfChannelsKey: 2] as [String : Any]
            
            do {
                soundRecoder = try AVAudioRecorder(url: getFilePath(), settings: audioSettings)
                soundRecoder.delegate = self
                soundRecoder.record()
            }catch{
                soundRecoder.stop()
                soundRecoder = nil
            }
        } catch {
            // failed to record!
            print("failed to record!")
        }
    }
    
    //AVAudioPlayerの準備
    func preparePalyer() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryAmbient)
            try audioSession.setActive(true)
            
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: getFilePath())
                soundPlayer.delegate = self
                soundPlayer.play()
            }catch {
                print("failed to Play!")
                if soundPlayer != nil {
                    soundPlayer.stop()
                    soundPlayer = nil
                }
                let alertController = UIAlertController(title: "No Data", message: "録音してください", preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(okButton)
                
                present(alertController,animated: true, completion: nil)
            }
        } catch {
            print("failed to Play!")
        }
    }
    
    //ディレクトリURLの取得
    func getFileDirPath() -> URL {
        let fileDirPath = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        //let fileDirPath = NSTemporaryDirectory()
        return fileDirPath[0]
        
    }
    
    //ファイルURL作成
    func getFilePath() -> URL{
        let filePath = getFileDirPath().appendingPathComponent("recording.m4a")
        //let filePath = URL(fileURLWithPath: getFileDirPath() + "recording.m4a")
        print(filePath)
        return filePath
    }

    
    @IBAction func tapRecordButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Record" {
            prepareRecoder()
            recordButton.setTitle("Stop", for: .normal)
            playButton.isEnabled = false
        }else{
            soundRecoder.stop()
            soundRecoder = nil
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
        }
    }

    @IBAction func tapPlayButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            preparePalyer()
            
            playButton.setTitle("Stop", for: .normal)
            
            recordButton.isEnabled = false
            
        }else{
            if soundPlayer != nil {
                soundPlayer.stop()
                soundPlayer = nil
            }
            playButton.setTitle("Play", for: .normal)
            recordButton.isEnabled = true
        }
    }
    
    @IBAction func tapDeleteButton(_ sender: Any) {
        let alertController = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            
            if self.soundRecoder.isRecording {
                self.soundRecoder.deleteRecording()
                self.deleteButton.isEnabled = false
            }else{
                print("録音されていません")
            }
        }
        alertController.addAction(okButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
        
    }
    //レコード処理が終わった後の動作
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //deleteButton.isEnabled = true
    }
    
    //再生処理が終わった後の動作
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playButton.setTitle("Play", for: .normal)
    }
    
    


}
