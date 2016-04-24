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
    let circleRadius: CGFloat = 100.0
    
    let unsafeColor = UIColor(red: 0xFF / 255.0, green: 0xDA / 255.0, blue: 0x00 / 255.0, alpha: 1.0).CGColor
    let safeColor = UIColor(red: 0x4C / 255.0, green: 0xD9 / 255.0, blue: 0x64 / 255.0, alpha: 1.0).CGColor
    
    var holdCompleted = false
    var switchVal = false
    
    var updateTimer: NSTimer!
    var waitAnimateTimer: NSTimer!
    
    @IBOutlet weak var holdButton: UIButton!
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        circlePathLayer.frame = view.bounds
        circlePathLayer.path = circlePath().CGPath
        holdButton.frame = circleFrame()
    }
    
    // MARK: Draw methods

    func drawCircularLoader() {
        circlePathLayer.frame = view.bounds
        circlePathLayer.lineWidth = 10
        circlePathLayer.lineCap = kCALineCapRound
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
        circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds) - CGRectGetMidY(circleFrame) - 130
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: circleFrame())
    }
    
    // MARK: Update methods
    
    func fillPath() {
        circlePathLayer.strokeEnd += 0.01
        
        if circlePathLayer.strokeEnd > 1 {
            updateTimer.invalidate()
            holdCompleted = true
            performOperation()
//            switchStates()
//            circlePathLayer.strokeEnd = 0
        }
    }
    
    func reversePath() {
        circlePathLayer.strokeEnd -= 0.05
        
        if circlePathLayer.strokeEnd < 0 {
            updateTimer.invalidate()
        }
    }
    
    func switchStates() {
        circlePathLayer.fillColor = switchVal ? safeColor : unsafeColor
        circlePathLayer.strokeColor = switchVal ? unsafeColor : safeColor
        switchVal = !switchVal
    }
    
    func performOperation() {
        print("Some operation triggered")
        waitAnimateTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "waitAnimate", userInfo: nil, repeats: true)
    }
    
//    var endsAnimateSwitch = true
//    func endsAnimate() {
//        if circlePathLayer.strokeEnd < 0.5 {
//            endsAnimateSwitch = false
//        } else if circlePathLayer.strokeEnd > 1 {
//            endsAnimateSwitch = true
//        }
//        if endsAnimateSwitch {
//            circlePathLayer.strokeEnd -= 0.01
//            circlePathLayer.strokeStart += 0.01
//        } else {
//            circlePathLayer.strokeEnd += 0.01
//            circlePathLayer.strokeStart -= 0.01
//        }
//    }
    
    var waitAnimateSwitch = false
    var i = 0
    func waitAnimate() {
//        circlePathLayer.lineDashPattern = [5]
//        circlePathLayer.lineCap = waitAnimateSwitch ? kCALineCapRound : kCALineCapButt
        circlePathLayer.lineWidth = waitAnimateSwitch ? 10 : 0
        waitAnimateSwitch = !waitAnimateSwitch
        
        if i++ == 5 {
            i = 0
            waitAnimateTimer.invalidate()
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            circlePathLayer.strokeEnd = 0
            CATransaction.commit()
            
            holdCompleted = false
            switchStates()
        }
    }
    
//
//    var a = 2
//    func shrinkAnimate() {
//        a = a + 2
//        if a == 8 {
//            a = 2
//        }
//        circlePathLayer.lineDashPattern = [a]
//    }
    
    // MARK: Button methods

    @IBAction func buttonHold(sender: UIButton) {
        print("hold")
//        holdCompleted = false
        if let _ = updateTimer {
            updateTimer.invalidate()
        }
        if !holdCompleted {
            updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "fillPath", userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func buttonRelease(sender: UIButton) {
        print("release")
        if let _ = updateTimer {
            updateTimer.invalidate()
        }
        if !holdCompleted {
            updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "reversePath", userInfo: nil, repeats: true)
        }
    }
    
}

