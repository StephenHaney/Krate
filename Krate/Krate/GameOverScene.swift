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
        let gameOverText = SKLabelNode(text: "!! \n" + game.score.formattedTotalScore());
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
