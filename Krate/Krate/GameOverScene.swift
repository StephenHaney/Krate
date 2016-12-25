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
        let scoreRank = game.highScores.addNewScore(game.score.totalScore); // zero based
        
        for index in -2...2 {
            let scoreIndex = scoreRank + index;

            if (scoreIndex >= 0 && scoreIndex < game.highScores.scores.count) {
                let positionYOffset = CGFloat(30 * index);
                let scoreLbl = SKLabelNode();
                let highScore = game.highScores.scores[scoreIndex];
                
                if (index == 0) {
                    scoreLbl.fontSize = 23;
                }
                else {
                    scoreLbl.fontSize = 18;
                }

                scoreLbl.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - positionYOffset);
                scoreLbl.fontColor = SKColor.whiteColor();
                scoreLbl.text = String(scoreIndex + 1) + " - " + highScore.formattedDate() + " - " + highScore.formattedScore();
                self.addChild(scoreLbl);
            }
        }
        

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
