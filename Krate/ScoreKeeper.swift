//
//  ScoreKeeper.swift
//  Krate
//
//  Created by Stephen Haney on 7/21/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit
import Foundation

class ScoreKeeper {
    let sprite = SKSpriteNode();
    var totalScore:Int = 0;
    let totalScoreLbl = SKLabelNode(fontNamed: "Avenir-Black");
    var scoreMultiplier:Float = 1;
    let defaultScoreText = "0000000000";
    
    init() {
        sprite.position = CGPoint(x: 0, y: 0);
        sprite.zPosition = 2000;
        
        self.totalScoreLbl.text = defaultScoreText;
        self.totalScoreLbl.fontSize = 42;
        self.totalScoreLbl.position = CGPoint(x: 0, y: -5);
        self.sprite.addChild(totalScoreLbl);
    }
    
    func setupListeners() {
        game.events.listenTo("tile-placed", action: { self.addScore(10) } );
        game.events.listenTo("tiles-cleared", action: { self.addScore(80) } );
    }
    
    func addScore(scoreAmount:Int) {
        let amountToAdd:Int = Int(Float(scoreAmount) * self.scoreMultiplier);
        
        self.totalScore += amountToAdd;
        
        self.totalScoreLbl.text = formattedTotalScore();
    }

    func formattedTotalScore() -> String {
        let totalScoreStr = String(self.totalScore);
        let leading0s = (defaultScoreText as NSString).substringFromIndex(countElements(totalScoreStr));

        return leading0s + totalScoreStr;
    }
}