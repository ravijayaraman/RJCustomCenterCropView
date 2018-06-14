//
//  RJCustomCenterCrop.swift
//  demo_bezierpath
//
//  Created by Ravi Jayaraman on 17/01/18.
//  Copyright © 2018 Ravi Jayaraman. All rights reserved.
//

import UIKit
import QuartzCore

/// Enum to add crop on
///
/// - topLeft: crop on top left side of rect
/// - centerTop: crop on top center side of rect
/// - topRight: crop on top right side of rect
/// - centerRight: crop on top left side of rect
/// - bottomRight: crop on bottom right side of rect
/// - centerBottom: crop on center bottom side of rect
/// - bottomLeft: crop on bottom left side of rect
/// - centerLeft: crop on left center side of rect
enum cropOn {
    case topLeft
    case centerTop
    case topRight
    case centerRight
    case bottomRight
    case centerBottom
    case bottomLeft
    case centerLeft
}


/// Function to customize the corner of views
class RJCustomCenterCrop: UIView {

    @IBInspectable
    public var lineColor: UIColor = MBUtils.shared.convertHexColor(name: MBThemeConstant.shared.FontColorWhite)
    
    @IBInspectable
    public var lineWidth: CGFloat = CGFloat(0)
    
    @IBInspectable
    public var clockwise: Bool = true
    
    @IBInspectable
    public var circularCrop: Bool = true
    
    @IBInspectable
    public var round: Bool = false
    
    @IBInspectable
    public var dashed: Bool = false
    
    @IBInspectable
    public var cropRadius: CGFloat = CGFloat(UIScreen.main.bounds.width * 0.05) {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.setNeedsDisplay()
            self.layoutSubviews()
        }
    }
    
    @IBInspectable
    public var tableCornerRadius: CGFloat = CGFloat(5)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initBackgroundColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBackgroundColor()
    }
    
    override public func prepareForInterfaceBuilder() {
        initBackgroundColor()
    }
    
    override public func draw(_ rect: CGRect) {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = tableCornerRadius
        
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        configurePath(path: path, rect: rect)
        
        lineColor.setFill()
        path.fill()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initBackgroundColor() {
        backgroundColor = UIColor.clear
    }
    
    /// Function to configure the path for rect
    ///
    /// - Parameters:
    ///   - path: Bezier path object
    ///   - rect: current rect
    ///   - lineType: Dashed or Plain
    private func configurePath(path: UIBezierPath, rect: CGRect, lineType: Bool = false) {
        
        if circularCrop {
            
            //Set path to the drawing context
            path.move(to: CGPoint(x: (rect.maxX - rect.minX)/2 - lineWidth - cropRadius, y: rect.minY))
            path.addArc(withCenter: CGPoint(x: (rect.maxX - rect.minX)/2, y: rect.minY + lineWidth + cropRadius * 0.64 - cropRadius), radius: cropRadius + lineWidth, startAngle: CGFloat.pi - CGFloat.pi * 0.07, endAngle: CGFloat.pi * 0.07, clockwise: false)
            path.addLine(to: CGPoint(x: rect.maxX - lineWidth - tableCornerRadius, y: rect.minY))
            path.addArc(withCenter: CGPoint(x: rect.maxX - lineWidth - tableCornerRadius, y: rect.minY + tableCornerRadius), radius: tableCornerRadius, startAngle: (3 * CGFloat.pi)/2, endAngle: 0, clockwise: true)
            path.addLine(to: CGPoint(x: rect.maxX - lineWidth, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + lineWidth, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + lineWidth, y: rect.minY + lineWidth + tableCornerRadius))
            path.addArc(withCenter: CGPoint(x: rect.minX + lineWidth + tableCornerRadius, y: rect.minY + tableCornerRadius), radius: tableCornerRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi + CGFloat.pi/2, clockwise: true)
            path.close()
        }
        else {
            
            //Set path to the drawing context
            path.move(to: CGPoint(x: (rect.maxX - rect.minX)/2 - lineWidth - cropRadius * 0.6, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + cropRadius * 0.4))
            path.addLine(to: CGPoint(x: (rect.maxX - rect.minX)/2 + lineWidth + cropRadius * 0.6, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - lineWidth - tableCornerRadius, y: rect.minY))
            path.addArc(withCenter: CGPoint(x: rect.maxX - lineWidth - tableCornerRadius, y: rect.minY + tableCornerRadius), radius: tableCornerRadius, startAngle: (3 * CGFloat.pi)/2, endAngle: 0, clockwise: true)
            path.addLine(to: CGPoint(x: rect.maxX - lineWidth, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + lineWidth, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + lineWidth, y: rect.minY + lineWidth + tableCornerRadius))
            path.addArc(withCenter: CGPoint(x: rect.minX + lineWidth + tableCornerRadius, y: rect.minY + tableCornerRadius), radius: tableCornerRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi + CGFloat.pi/2, clockwise: true)
            path.close()
        }
    
        self.layer.cornerRadius = tableCornerRadius
        self.clipsToBounds = true
        
        if lineType {
            let dashes: [CGFloat] = [lineWidth, lineWidth]
            path.setLineDash(dashes, count: dashes.count, phase: 0)
        }
        
        if round {
            path.lineCapStyle = .butt
        }
        else {
            path.lineCapStyle = .round
        }
        
    }
}
