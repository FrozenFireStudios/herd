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
        
        view.backgroundColor = UIColor.greenColor()
        
        view.addSubview(stack)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(startButton)
        
        stack.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        stack.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        
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
    // MARK: - Views
    //==========================================================================
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.axis = .Vertical
        stack.alignment = .Center
        stack.distribution = .FillProportionally
        stack.spacing = 80
        stack.setContentHuggingPriority(1000, forAxis: .Vertical)
        
        return stack
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "farmer"))
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(108)
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.text = "Counting\nSheep"
        return label
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .RoundedRect)
        button.titleLabel?.font = UIFont.systemFontOfSize(72)
        button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        button.setTitle("Start", forState: .Normal)
        return button
    }()
    
}
