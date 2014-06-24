//
//  World.swift
//  Krate
//
//  Created by Stephen Haney on 6/14/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit

class World {
    let canvas = SKSpriteNode();
    
    init() {
        canvas.anchorPoint = CGPoint(x: 0.5, y: 0.5);
    }

    func zoomOut(scale:Float) {
        let scaleAction = SKAction.scaleTo(scale, duration: 0.5);
        let rotateAction = SKAction.rotateToAngle(1.57079633, duration: 0.5);
        let actionGroup = SKAction.group([scaleAction, rotateAction]);
        
        canvas.runAction(actionGroup);
    }
}