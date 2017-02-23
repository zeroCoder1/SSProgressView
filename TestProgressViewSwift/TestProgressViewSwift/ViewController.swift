//
//  ViewController.swift
//  TestProgressViewSwift
//
//  Created by Sharma, Shrutesh on 2/1/16.
//  Copyright © 2016 wand. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ssProgressView: SSProgressView? = SSProgressView()
    
    @IBOutlet weak var download: UIButton!
    var prog = Float()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ssProgressView!.lineColor = UIColor.white
        ssProgressView!.dottedLineColor = UIColor.white
        addGradientBackgroundLayer()
    }

    func update(){
        prog+=0.001
        if(prog*100 > 100){
            download.setTitle("Done", for: UIControlState())
            ssProgressView!.updateProgressViewWith(Float(100), totalFileSize: Float(100))
            timer.invalidate()
        }else{
            download.setTitle("Downloading", for: UIControlState())
            self.ssProgressView!.animateProgressViewToProgress(prog)
            self.ssProgressView!.updateProgressViewLabelWithProgress(prog * 100)
            ssProgressView!.updateProgressViewWith(Float(prog*100), totalFileSize: Float(100))
        }
    }

    @IBAction func downloadBtnActn(_ sender: UIButton) {
        timer.invalidate()
        prog = 0
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true);
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    func addGradientBackgroundLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        
        let colorTop: AnyObject = UIColor(red: 32.3/255.0, green: 173.8/255.0, blue: 218.9/255.0, alpha: 1.0).cgColor
        let colorBottom: AnyObject = UIColor(red: 122.9/255.0, green: 107.7/255.0, blue: 178.4/255.0, alpha: 1.0).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

