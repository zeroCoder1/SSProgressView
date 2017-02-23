//
//  SSProgressView.swift
//  TestProgressViewSwift
//
//  Created by Sharma, Shrutesh on 2/1/16.
//  Copyright © 2016 wand. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics

@IBDesignable class SSProgressView: UIView {
    
    fileprivate let progressLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var progressLabel: UILabel = UILabel()
    fileprivate var sizeProgressLabel :UILabel = UILabel()
    fileprivate var dashedLayer: CAShapeLayer = CAShapeLayer()
    
    @IBInspectable var lineColor: UIColor = UIColor.white{
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var dottedLineColor: UIColor = UIColor.white{
        didSet {
            self.setNeedsLayout()
        }
    }
    

    required init(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    fileprivate func setupView(){
        backgroundColor = UIColor.clear
        createProgressLayer()
        createLabel()
    }
    
    func createLabel(){
        
        progressLabel = UILabel()
        progressLabel.textColor = .white
        progressLabel.textAlignment = .center
        progressLabel.text = "0%"
        progressLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 40.0)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressLabel)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: progressLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: progressLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))

        
        sizeProgressLabel = UILabel()
        sizeProgressLabel.textColor = .white
        sizeProgressLabel.textAlignment = .center
        sizeProgressLabel.text = "0.0 MB / 0.0 MB"
        sizeProgressLabel.font = UIFont(name: "HelveticaNeue-Light", size: 10.0)
        sizeProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sizeProgressLabel)

        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: sizeProgressLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: progressLabel, attribute: .bottom, relatedBy: .equal, toItem: sizeProgressLabel, attribute: .top, multiplier: 1.0, constant: -10.0))
    }
    
    
    fileprivate func createProgressLayer() {
        let startAngle = CGFloat(M_PI_2)
        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
        let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: frame.width/2 - 10.0, startAngle:startAngle, endAngle:endAngle, clockwise: true).cgPath
        progressLayer.backgroundColor = UIColor.clear.cgColor
        progressLayer.fillColor = nil
        progressLayer.lineWidth = 4.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        
        layer.addSublayer(progressLayer)
        
        dashedLayer.fillColor = nil
        dashedLayer.lineDashPattern = [2, 4]
        dashedLayer.lineJoin = "round"
        dashedLayer.lineWidth = 2.0
        dashedLayer.path = progressLayer.path
        layer.insertSublayer(dashedLayer, below: progressLayer)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        let c1 = UIColor(red: 9.5/255.0, green: 46.6/255.0, blue: 62.5/255.0, alpha: 1.0)
        let c2 = UIColor(red: 122.9/255.0, green: 107.7/255.0, blue: 178.4/255.0, alpha: 1.0)
        gradientLayer.colors = [c2.cgColor as AnyObject, c1.cgColor as AnyObject];
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = progressLayer
    
    }
    
    func animateProgressViewToProgress(_ progress: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(progressLayer.strokeEnd)
        animation.toValue = CGFloat(progress)
        animation.duration = 0.2
        animation.fillMode = kCAFillModeForwards
        progressLayer.strokeEnd = CGFloat(progress)
        progressLayer.add(animation, forKey: "animation")
    }
    
    func updateProgressViewLabelWithProgress(_ percent: Float) {
        progressLabel.text = NSString(format: "%.0f %@", percent, "%") as String
    }
    
    func updateProgressViewWith(_ totalSent: Float, totalFileSize: Float) {
       // sizeProgressLabel.text = NSString(format: "%.1f MB / %.1f MB", convertFileSizeToMegabyte(totalSent), convertFileSizeToMegabyte(totalFileSize)) as String
        sizeProgressLabel.text = NSString(format: "%.1f MB / %.1f MB", totalSent, totalFileSize) as String
    }
    
    fileprivate func convertFileSizeToMegabyte(_ size: Float) -> Float {
        return (size / 1024) / 1024
    }
    
    override func draw(_ rect: CGRect) {
        progressLayer.strokeColor = self.lineColor.cgColor
        dashedLayer.strokeColor = self.dottedLineColor.cgColor
    }
    
    func hideProgressView() {
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
    }
    
     func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        hideProgressView()
    }

}
