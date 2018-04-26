//
//  PGActivityIndicator.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 24/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit

@IBDesignable
class PGActivityIndicator: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    @IBInspectable open var trackBorderWidth: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var color : UIColor = UIColor.red {
        didSet{ setNeedsDisplay() }
    }
    @IBInspectable var lineWidth : CGFloat = 2 {
        didSet{ setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
//        self.backgroundColor = UIColor.clear
        
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        let size = bounds.size
        
        
        let radius = size.width<size.height ? size.width/2 : size.height/2
        let center = CGPoint(x: size.width/2, y: size.height/2)
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat((2 - 1/20.0)*Double.pi), clockwise: true)
//        self.layer.anchorPoint = center
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = lineWidth
        layer.path = path.cgPath
        layer.lineCap = kCALineCapRound
        
//        Animation
        let beginTime: Double = 0.5
        let strokeStartDuration: Double = 1.2
        let strokeEndDuration: Double = 0.7
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.byValue = Float.pi * 2
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = strokeEndDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = strokeStartDuration
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.beginTime = beginTime
        
        let groupAnimation  = CAAnimationGroup()
        groupAnimation.animations = [rotationAnimation,strokeEndAnimation,strokeStartAnimation]
        groupAnimation.duration = strokeStartDuration + beginTime
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        
        
        /// SetupFrame
        let frame = CGRect(
            x: (self.layer.bounds.width - size.width) / 2,
            y: (self.layer.bounds.height - size.height) / 2,
            width: size.width,
            height: size.height
        )
        layer.frame = frame
        
        layer.add(groupAnimation, forKey: "animation")
        self.layer.addSublayer(layer)
    }
    
     

}
