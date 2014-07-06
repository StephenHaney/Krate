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
    var initialPosition:CGPoint?;
    var zoomedOut = 0;
    
    init() {
        canvas.anchorPoint = CGPoint(x: 0.5, y: 0.5);
    }

    func pregameZoom() {
        let initialZoom = SKAction.scaleTo(0.1, duration: 0);
        canvas.runAction(initialZoom);
        let zoomIn = SKAction.group([ SKAction.scaleTo(1, duration: 2.4), SKAction.rotateByAngle(Float(M_PI * 2.0), duration: 3) ]);
        zoomIn.timingMode = SKActionTimingMode.EaseOut;
        canvas.runAction(zoomIn, completion: {
            game.performingIntro = false;
            self.shakeCamera(0.5);
        } );
    }
    
    func zoomOut(scale:Float) {
        let scaleAction = SKAction.scaleTo(scale, duration: 0.5);
        let rotateAction = SKAction.rotateByAngle(Float(M_PI * 0.5), duration: 0.5);
        let actionGroup = SKAction.group([scaleAction, rotateAction]);
        zoomedOut++;
        
        canvas.runAction(actionGroup);
    }
    
    func shakeCamera(duration:Float) {
        if !initialPosition {
            initialPosition = canvas.position;
        }
        
        let startingX = initialPosition!.x;
        let startingY = initialPosition!.y;
        let amplitudeX:Int = 12;
        let amplitudeY:Int = 3;
        let numberOfShakes = duration / 0.03;
        var actionsArray:SKAction[] = [];
        for index in 1...Int(numberOfShakes) {
            // build a new random shake and add it to the list
            let newXPos = startingX + Float(game.randomNum(amplitudeX) - amplitudeX / 2);
            let newYPos = startingY + Float(game.randomNum(amplitudeY) - amplitudeY / 2);
            let shakeAction = SKAction.moveTo(CGPointMake(newXPos, newYPos), duration: 0.03);
            shakeAction.timingMode = SKActionTimingMode.EaseOut;
            actionsArray.append(shakeAction);
        }
        
        // reset to original position
        actionsArray.append(SKAction.moveTo(initialPosition!, duration: 0.03));

        let actionSeq = SKAction.sequence(actionsArray);
        canvas.runAction(actionSeq);
    }
}