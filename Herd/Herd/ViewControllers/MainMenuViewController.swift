//
//  MainMenuViewController.swift
//  Herd
//
//  Created by Marcus Smith on 8/24/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(startButton)
        
        startButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        startButton.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        
        startButton.addTarget(self, action: #selector(buttonTapped), forControlEvents: .TouchUpInside)
    }
    
    //==========================================================================
    // MARK: - Actions
    //==========================================================================
    func buttonTapped() {
        let gameVC = GameViewController()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    //==========================================================================
    // MARK: - Update
    //==========================================================================
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .RoundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", forState: .Normal)
        return button
    }()
    
}
