//
//  SVGPath.swift
//  SVGPlayground
//
//  Created by Austin Fitzpatrick on 3/18/15.
//  Copyright (c) 2015 Seedling. All rights reserved.
//

import UIKit

/// An SVGPath is the most common SVGDrawable element in an SVGVectorImage
/// it contains a bezier path and instructions for drawing it to the canvas
/// with its draw() method
class SVGPath: SVGGroupable {
    
    var bezierPath:UIBezierPath // The bezier path to draw to the canvas
    var fill:SVGFillable?       // The fill for the bezier path - commonly
                                // a UIColor or SVGGradient
    
    var opacity:CGFloat         // The opacity to draw the path at
    var group:SVGGroup?         // The group that this path belongs to - if any
    
    var bounds:CGRect           //the path's bounds
        { return bezierPath.bounds }
    
    /// Initializes a SVGPath
    ///
    /// :param: bezierPath The UIBezierPath to use for drawing to the canvas
    /// :param: fill An Object conforming to Fillable to use as the fill. UIColor and SVGGradient are common choices
    /// :param: opacity The opacity to draw the path at
    /// :returns: an SVGPath ready for drawing with draw()
    init(bezierPath:UIBezierPath, fill:SVGFillable?, opacity:CGFloat = 1.0){
        self.bezierPath = bezierPath
        self.fill = fill ?? UIColor.blackColor()
        self.opacity = opacity
    }
    
    /// Draws the SVGPath to the canvas
    func draw(){
        if let color = fill?.asColor() {
            if opacity != 1 {
                color.colorWithAlphaComponent(opacity).setFill()
            } else {
                color.setFill()
            }
            bezierPath.fill()
        } else if let gradient = fill?.asGradient() as? SVGRadialGradient {
            let context = UIGraphicsGetCurrentContext()
            CGContextSaveGState(context)
            bezierPath.addClip()
            CGContextDrawRadialGradient(context, gradient.CGGradientWithOpacity(opacity),
                gradient.center, 0,
                gradient.center, gradient.radius,
                UInt32(kCGGradientDrawsBeforeStartLocation) | UInt32(kCGGradientDrawsAfterEndLocation))
            CGContextRestoreGState(context)
        }
        
    }
    
}