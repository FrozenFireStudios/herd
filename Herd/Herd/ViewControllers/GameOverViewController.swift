//
//  GameOverViewController.swift
//  Herd
//
//  Created by Marcus Smith on 8/24/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
   
    let score: Int
    let won: Bool
    
    init(score: Int, won: Bool) {
        self.score = score
        self.won = won
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Conductor.sharedInstance.backgroundMusic.stop()
        
        view.backgroundColor = .whiteColor()
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(wonLabel)
        stackView.addArrangedSubview(scoreLabel)
        stackView.addArrangedSubview(finishButton)
        
    
        stackView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        stackView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        
        if won {
            wonLabel.text = "YOU WON!"
        }
        else {
            wonLabel.text = "YOU LOST!"
        }
        
        
        scoreLabel.text = "Score: \(score)"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if won {
            Conductor.sharedInstance.playSound(forKey: .CrowdCheeringKey)
        }
        else {
            Conductor.sharedInstance.playSound(forKey: .CrowdBooingKey)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //==========================================================================
    // MARK: - Actions
    //==========================================================================
    
    func finish() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .Vertical
        stack.alignment = .Center
        
        return stack
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var wonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var finishButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blueColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Finish", forState: .Normal)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.addTarget(self, action: #selector(GameOverViewController.finish), forControlEvents: .TouchUpInside)
        return button
    }()
}
