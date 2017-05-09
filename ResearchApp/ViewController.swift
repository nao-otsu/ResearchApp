//
//  ViewController.swift
//  ResearchApp
//
//  Created by 夏山聡史 on 2017/04/18.
//  Copyright © 2017年 夏山聡史. All rights reserved.
//

import UIKit
import CoreMotion //モーションデータを使うフレームワーク

class ViewController: UIViewController {
    
    
    @IBOutlet weak var XLabel: UILabel!
    @IBOutlet weak var YLabel: UILabel!
    @IBOutlet weak var ZLabel: UILabel!
    
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加速度センサーが利用可能か
        if motionManager.isAccelerometerAvailable {
            //更新間隔
            motionManager.accelerometerUpdateInterval = 0.1
            //データの取得メソッド プッシュ型
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                if let accelerationX = data?.acceleration.x {
                    self.XLabel.text = String(accelerationX)
                }
                if let accelerationY = data?.acceleration.y {
                    self.YLabel.text = String(accelerationY)
                }
                if let accelerationZ = data?.acceleration.z {
                    self.ZLabel.text = String(accelerationZ)
                }
            }
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

}

