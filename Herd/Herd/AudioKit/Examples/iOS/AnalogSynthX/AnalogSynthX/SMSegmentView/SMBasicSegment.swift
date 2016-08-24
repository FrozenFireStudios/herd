//
//  SMBasicSegment.swift
//  SMSegmentViewController
//
//  Created by mlaskowski on 01/10/15.
//  Copyright © 2016 si.ma. All rights reserved.
//

import Foundation
import UIKit

public class SMBasicSegment : UIView {
    public internal(set) var index: Int = 0
    public internal(set) weak var segmentView: SMBasicSegmentView?
    
    public private(set) var isSelected: Bool = false
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: Selections
    internal func setSelected(selected: Bool, inView view: SMBasicSegmentView) {
        self.isSelected = selected
    }
    
    public func orientationChangedTo(mode: SegmentOrganiseMode){
        
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if self.isSelected == false{
            self.segmentView?.selectSegmentAtIndex(self.index)
        }
    }
}