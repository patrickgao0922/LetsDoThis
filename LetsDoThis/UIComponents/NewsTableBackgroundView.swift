//
//  NewsTableBackgroundView.swift
//  LetsDoThis
//
//  Created by Patrick Gao on 30/4/18.
//  Copyright © 2018 Patrick Gao. All rights reserved.
//

import UIKit

class NewsTableBackgroundView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawBackgroundShap(rect)
    }
    
    func drawBackgroundShap(_ rect:CGRect) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        let baseTransform = context.userSpaceToDeviceSpaceTransform.inverted()
        
        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = NewsTVBackgroundShap.ResizingBehavior.aspectFit.apply(rect: CGRect(x: 0, y: 0, width: 750, height: 1334), target: rect)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 750, y: resizedFrame.height / 1334)
        
        /// Background Color
        UIColor(hue: 0.563, saturation: 0.033, brightness: 0.965, alpha: 1).setFill()
        context.fill(context.boundingBoxOfClipPath)
        
        /// Bg Shape
        let bgShape = UIBezierPath()
        bgShape.move(to: CGPoint(x: 58.84, y: 12.56))
        bgShape.addCurve(to: CGPoint(x: 525.97, y: 210.45), controlPoint1: CGPoint(x: 58.84, y: 12.56), controlPoint2: CGPoint(x: 829.53, y: -74.62))
        bgShape.addCurve(to: CGPoint(x: 728.29, y: 544.77), controlPoint1: CGPoint(x: 222.42, y: 495.53), controlPoint2: CGPoint(x: 728.29, y: 544.77))
        bgShape.addCurve(to: CGPoint(x: 728.29, y: 990.09), controlPoint1: CGPoint(x: 728.29, y: 544.77), controlPoint2: CGPoint(x: 1129.37, y: 595.78))
        bgShape.addCurve(to: CGPoint(x: 778.42, y: 1665.42), controlPoint1: CGPoint(x: 475.06, y: 1239.05), controlPoint2: CGPoint(x: 1625.89, y: 1896.98))
        bgShape.addCurve(to: CGPoint(x: 103.24, y: 1027.28), controlPoint1: CGPoint(x: 132.68, y: 1488.97), controlPoint2: CGPoint(x: 326.08, y: 1179.07))
        bgShape.addCurve(to: CGPoint(x: 261.1, y: 474.52), controlPoint1: CGPoint(x: -119.59, y: 875.49), controlPoint2: CGPoint(x: 687.41, y: 855.48))
        bgShape.addCurve(to: CGPoint(x: 58.84, y: 12.56), controlPoint1: CGPoint(x: -165.21, y: 93.55), controlPoint2: CGPoint(x: 58.84, y: 12.56))
        bgShape.close()
        bgShape.move(to: CGPoint(x: 58.84, y: 12.56))
        context.saveGState()
        context.translateBy(x: 577.5, y: 592)
        context.rotate(by: 540 * CGFloat.pi/180)
        context.translateBy(x: -547.5, y: -857)
        bgShape.usesEvenOddFillRule = true
        UIColor(hue: 0.506, saturation: 0.66, brightness: 0.8, alpha: 1).setFill()
        bgShape.fill()
//        let bgShapeLayer = CAShapeLayer()
//        bgShapeLayer.path = bgShape.cgPath
//        self.layer.insertSublayer(bgShapeLayer, at: 0)
        context.restoreGState()
    }

}
