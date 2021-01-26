//
//  File.swift
//  Transition
//
//  Created by DMR on 2021/1/25.
//

import UIKit


open class DismissScaleAnimation: Transition {
    
    public var centerFrame = CGRect(x: (kScreenWidth - 5)*0.5, y: (kScreenHeight - 5)*0.5, width: 5, height: 5)
    public var originCellFrame: CGRect?
    public var finalCellFrame: CGRect?
    public var selectCell: UIView?
    
    
    
    
    public override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        guard let finalCellFrame = finalCellFrame,let selectCell = selectCell  else {
            return
        }
        
        var snapshotView: UIView!
        var scaleRatio: CGFloat = 1.0
        var finalFrame = finalCellFrame
        if self.selectCell != nil && !finalFrame.equalTo(.zero) {
            snapshotView = selectCell.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.frame.size.width/selectCell.frame.size.width
            snapshotView.layer.zPosition = 20
        } else {
            snapshotView = fromVC.view.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.frame.size.width/kScreenWidth
            finalFrame = centerFrame
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(snapshotView)
        
        let duration = transitionDuration(using: transitionContext)
        
        fromVC.view.alpha = 0.0
        snapshotView.center = fromVC.view.center
        snapshotView.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio);
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            
            snapshotView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            snapshotView.frame = finalFrame
        }, completion: { (finished) in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
            snapshotView.removeFromSuperview()
        })
    }
    
}
