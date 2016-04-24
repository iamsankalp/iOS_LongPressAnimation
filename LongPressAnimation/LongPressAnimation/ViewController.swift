//
//  ViewController.swift
//  LongPressAnimation
//
//  Created by Diwakar Kamboj on 24/04/16.
//
//

import UIKit

class ViewController: UIViewController {
    
    let circlePathLayer = CAShapeLayer()
    let circleRadius: CGFloat = 20.0
    
    let unsafeColor = UIColor.redColor().CGColor
    let safeColor = UIColor.grayColor().CGColor
    
    var updateTimer: NSTimer!
    
//    var progress: CGFloat {
//        get {
//            return circlePathLayer.strokeEnd
//        } set {
//            circlePathLayer.strokeEnd = newValue
//            circlePathLayer.strokeStart = newValue - 0.25
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        drawCircularLoader()
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "fillPath", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        circlePathLayer.frame = view.bounds
        circlePathLayer.path = circlePath().CGPath
    }
    
    // MARK: Draw methods

    func drawCircularLoader() {
        circlePathLayer.frame = view.bounds
        circlePathLayer.lineWidth = 2
        circlePathLayer.fillColor = safeColor
        circlePathLayer.strokeColor = unsafeColor
        view.layer.addSublayer(circlePathLayer)
        view.backgroundColor = UIColor.whiteColor()
        circlePathLayer.strokeEnd = 0
//        progress = 0
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds) - CGRectGetMidX(circleFrame)
        circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds) - CGRectGetMidY(circleFrame)
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: circleFrame())
    }
    
    // MARK: Update methods
    
    func fillPath() {
        circlePathLayer.strokeEnd += 0.01
        
        if circlePathLayer.strokeEnd > 0.7 {
            updateTimer.invalidate()
            
            updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "reversePath", userInfo: nil, repeats: true)
        }
    }
    
    func reversePath() {
        circlePathLayer.strokeEnd -= 0.05
        
        if circlePathLayer.strokeEnd < 0 {
            updateTimer.invalidate()
        }
    }

}

