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
    var zoomedOut = 0;
    
    init() {
    }
    
    func intro() { }
    
    /*func zoomOut(scale:Float) {
        let scaleAction = SKAction.scaleTo(scale, duration: 0.5);
        let rotateAction = SKAction.rotateByAngle(Float(M_PI * 0.5), duration: 0.5);
        let actionGroup = SKAction.group([scaleAction, rotateAction]);
        zoomedOut++;
        
        canvas.runAction(actionGroup);
    }
    
    func rotate(turns:Float) {
        let radianRotation = Float(M_PI);
        
        canvas.runAction(SKAction.rotateByAngle(radianRotation, duration: 100));
    }*/
    
    func shakeCamera(duration:Float) {
        let amplitudeX:Float = 10;
        let amplitudeY:Float = 6;
        let numberOfShakes = duration / 0.04;
        var actionsArray:[SKAction] = [];
        for index in 1...Int(numberOfShakes) {
            // build a new random shake and add it to the list
            let moveX = CGFloat(game.randomFloat(amplitudeX) - amplitudeX / 2);
            let moveY = CGFloat(game.randomFloat(amplitudeY) - amplitudeY / 2);
            let shakeAction = SKAction.moveByX(moveX, y: moveY, duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.EaseOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversedAction());
        }

        let actionSeq = SKAction.sequence(actionsArray);
        canvas.runAction(actionSeq);
    }
}