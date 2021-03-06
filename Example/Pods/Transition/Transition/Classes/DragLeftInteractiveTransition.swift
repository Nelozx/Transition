//
//  File.swift
//  Transition
//
//  Created by DMR on 2021/1/25.
//

import UIKit


open class DragLeftInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    fileprivate var presentingVC: UIViewController!
    
    fileprivate var viewControllerCenter: CGPoint!
    fileprivate lazy var transitionMaskLayer = CALayer()
    
    public var isInteracting = false

    public func writeToViewController(_ viewController: UIViewController) {
        self.presentingVC = viewController;
        self.viewControllerCenter = viewController.view.center
        self.prepareGestureRecognizer(in: viewController.view)
    }
    
    open override func update(_ percentComplete: CGFloat) {}
    
    open override func cancel() {}

    open override func finish() {}
    
}

extension DragLeftInteractiveTransition {
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        guard let vcView = gestureRecognizer.view else {
            return
        }
        let translation = gestureRecognizer.translation(in: vcView.superview)
        if !isInteracting &&
            (translation.x < 0 ||
                translation.y < 0 ||
                translation.x < translation.y) {
            return
        }
        
        switch gestureRecognizer.state {
        case .began:
            //修复当从右侧向左滑动的时候的bug 避免开始的时候从又向左滑动 当未开始的时候
            let vel = gestureRecognizer.velocity(in: vcView)
            
            if !isInteracting && vel.x < 0 {
                isInteracting = false
                return
            }
            transitionMaskLayer.frame = vcView.frame
            transitionMaskLayer.isOpaque = false
            transitionMaskLayer.opacity = 1
            transitionMaskLayer.backgroundColor = UIColor.white.cgColor //必须有颜色不能透明
            transitionMaskLayer.setNeedsLayout()
            transitionMaskLayer.displayIfNeeded()
            transitionMaskLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            transitionMaskLayer.position = CGPoint(x: vcView.frame.size.width*0.5,  y: vcView.frame.size.height*0.5)
            vcView.layer.mask = self.transitionMaskLayer
            vcView.layer.masksToBounds = true
            isInteracting = true
            break
        case .changed:
            var progress = translation.x / kScreenWidth
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            let ratio = 1.0 - progress*0.5
            presentingVC.view.center = CGPoint(x: viewControllerCenter.x + translation.x * ratio, y: viewControllerCenter.y + translation.y + ratio)
            
            presentingVC.view.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            
            break
        case .cancelled, .ended:
            var progress = translation.x/kScreenWidth
            
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            
            if progress < 0.2 {
                
                UIView.animate(withDuration: TimeInterval(progress), delay: 0, options: .curveEaseOut) {
                    self.presentingVC.view.center = CGPoint(x: kScreenWidth*0.5, y: kScreenHeight*0.5)
                    self.presentingVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                } completion: { (finised) in
                    self.isInteracting = false
                    self.cancel()
                }
            } else {
                isInteracting = false
                self.finish()
                presentingVC.dismiss(animated: true, completion: nil)
            }
            /// 移除 遮罩
            transitionMaskLayer.removeFromSuperlayer()
            break
        default:break
            
        }
        
    }
    
}
 
