//
//  ListViewController.swift
//  Transition_Example
//
//  Created by DMR on 2021/1/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit


class ListViewController: UIViewController {
    
    public var cell: UICollectionViewCell?
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cell = cell {
            
            self.view.backgroundColor = cell.backgroundColor
            
        }
        
        let btn = UIButton(frame: CGRect(x: 20, y: 100, width: view.bounds.width - 20 * 2, height: 44))
        
        btn.backgroundColor = RandomColor
        btn.setTitle("按钮", for: .normal)
        btn.setTitleColor(RandomColor, for: .normal)
        btn.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        self.view.addSubview(btn)
        
    }
    
    @objc private func tapButton() {
        self.dismiss(animated: true, completion: nil)
    }
    



}
