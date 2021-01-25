

import UIKit


let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

class PresentScaleAnimation: NSObject {
    
    /** cell在父视图的frame 不能为zero, 这个坐标 需要的是cell转换父视图完成之后的frame */
    public var cellConvertFrame: CGRect = CGRect(x: 1, y: 1, width: 1, height: 1)
}

extension PresentScaleAnimation: UIViewControllerAnimatedTransitioning {
    
    
    /// 过度时间
    /// - Parameter transitionContext: 上下文
    /// - Returns: dush
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        
        
        if self.cellConvertFrame.equalTo(.zero) {
            transitionContext.completeTransition(true)
            return
        }
        
        let initialFrame = cellConvertFrame
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)

        let finalFrame = transitionContext.finalFrame(for: toVC)
        let duration = transitionDuration(using: transitionContext)
        toVC.view.center = CGPoint(x: initialFrame.origin.x + initialFrame.size.width/2, y: initialFrame.origin.y + initialFrame.size.height/2)
        toVC.view.transform = CGAffineTransform(scaleX: initialFrame.size.width/finalFrame.size.width, y: initialFrame.size.height/finalFrame.size.height)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1,
                       options: .layoutSubviews) {
            
            toVC.view.center = CGPoint(x: finalFrame.origin.x + finalFrame.size.width/2, y: finalFrame.origin.y + finalFrame.size.height/2)
            toVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        } completion: { (finished) in
            transitionContext.completeTransition(true)
        }
    }
      

    
    
    
    
}

