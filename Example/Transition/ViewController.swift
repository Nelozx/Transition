//
//  ViewController.swift
//  Transition
//
//  Created by Nelo on 01/25/2021.
//  Copyright (c) 2021 Nelo. All rights reserved.
//

import UIKit
import Transition


var RandomColor: UIColor {
    let hue:CGFloat = CGFloat(arc4random()%256) / 256.0
    let saturation: CGFloat = CGFloat(arc4random()%128) / 256.0 + 0.5
    let brightness: CGFloat = CGFloat(arc4random()%128) / 256.0 + 0.5
    let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    return color
}

class ViewController: UIViewController {

    lazy var presentScaleAnimation = PresentScaleAnimation()
    lazy var dismissScaleAnimation = DismissScaleAnimation()
    lazy var leftDragInteractiveTransition = DragLeftInteractiveTransition()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView.dataSource = self
//        self.collectionView.delegate = self
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = RandomColor
        return cell
    }


}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let listVC = ListViewController()
        
        listVC.transitioningDelegate = self

        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        listVC.cell = cell
        let cellFrame = cell.frame
        let cellConvertedFrame = collectionView.convert(cellFrame, to: collectionView.superview)

        // 呈现转场
        presentScaleAnimation.cellConvertFrame = cellConvertedFrame

        // 消失转场
        dismissScaleAnimation.selectCell = cell
        dismissScaleAnimation.originCellFrame = cellFrame
        dismissScaleAnimation.finalCellFrame = cellConvertedFrame


        listVC.modalPresentationStyle = .overCurrentContext
        self.modalPresentationStyle = .currentContext

        leftDragInteractiveTransition.writeToViewController(listVC)
        present(listVC, animated: true, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentScaleAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissScaleAnimation
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return leftDragInteractiveTransition.isInteracting ? self.leftDragInteractiveTransition : nil
    }
    
    
}

 
