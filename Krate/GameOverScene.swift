//
//  GameOverScene.swift
//  Krate
//
//  Created by Stephen Haney on 7/5/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {

    override func didMoveToView(view: SKView) {
        /*let testSprite = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 3, height: 50));
        testSprite.position = CGPoint(x: 0, y: 0);
        testSprite.anchorPoint = CGPoint(x: 0, y: 0);
        self.addChild(testSprite);*/
        
        /*let testSprite2 = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 50, height: 50));
        testSprite2.position = CGPoint(x: 1, y: 1);
        testSprite2.anchorPoint = CGPoint(x: 0, y: 0);
        self.addChild(testSprite2);
        
        println(self.view.bounds.size);*/
        
        let gameOverText = SKLabelNode(text: "You lose!");
        gameOverText.fontSize = 42;
        gameOverText.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2);
        gameOverText.fontColor = SKColor.whiteColor();
        self.addChild(gameOverText);
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
