//
//  File.swift
//  Transition
//
//  Created by DMR on 2021/1/26.
//

import UIKit


let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height


open class Transition: NSObject {}

extension Transition: UIViewControllerAnimatedTransitioning {
    
    /// 过度转场时间 默认0.35
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.35
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {}
}
