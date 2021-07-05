//
//  Pulse.swift
//  trashApp
//
//  Created by Labdhi Jain on 4/9/20.
//  Copyright © 2020 Labdhi Jain. All rights reserved.
//

import Foundation
import UIKit

class Pulse: CALayer{
    
    var animationGroup = CAAnimationGroup()
    var animationDuration: TimeInterval = 1.5
    var radius : CGFloat = 200
    
    var numberOfPulses: Float = 10
    
    override init(layer:Any){
        super.init(layer:layer)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(numberOfPulses: Float = 10, radius : CGFloat, position: CGPoint){
        super.init()
        self.backgroundColor = UIColor.black.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.position = position
        
        self.bounds = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        self.cornerRadius = radius
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupAnimationGroup()
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
            }
        }
        
        
    }
    
    func scaleAnimation() -> CABasicAnimation{
        let scaleAnimation = CABasicAnimation(keyPath:"transform.scale.xy") // just for documentation
        scaleAnimation.fromValue = NSNumber(value: 0)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        return scaleAnimation
        
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation{
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity") // just for documentation
        opacityAnimation.duration = animationDuration
        opacityAnimation.keyTimes = [0,0.3,1]
        opacityAnimation.values = [0.4, 0.8, 0]
        return opacityAnimation
    }
    
    func setupAnimationGroup(){
        self.animationGroup.duration = animationDuration
        self.animationGroup.repeatCount = numberOfPulses
        let defaultCurve = CAMediaTimingFunction(name: .default) // pacing with respect to the time
        self.animationGroup.timingFunction = defaultCurve
        self.animationGroup.animations = [scaleAnimation(), createOpacityAnimation()]
        
        
    }

    
    
    
    
}
