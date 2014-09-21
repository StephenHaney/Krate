//
//  TheDarkness.swift
//  Krate
//
//  Created by Stephen Haney on 8/16/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit

class TheDarkness {
    var nextDisabledTile:Tile?;
    let warning = TileHighlight();
    var uniqueOffset:NSTimeInterval = 0;
    let uniqueKey:String;
    
    init(uniqueOffset:NSTimeInterval) {
        self.uniqueOffset = uniqueOffset;
        self.uniqueKey = "warning-" + uniqueOffset.description;
        
        updateTimer(game.levelManager.currentLevel.blackoutTimer);
    }

    func updateTimer(newTimer:NSTimeInterval) {
        game.world.canvas.removeActionForKey(uniqueKey);
        
        let blackoutSequence = SKAction.sequence([SKAction.waitForDuration(newTimer + uniqueOffset), SKAction.runBlock({ self.pickDisabledTile(); })]);
        let blackoutTimer = SKAction.repeatActionForever(blackoutSequence);
        
        game.world.canvas.runAction(blackoutTimer, withKey: uniqueKey);
    }
    
    func pickDisabledTile() {
        // disable the tile! (if there's one marked for it)
        if let disabledTile = self.nextDisabledTile {
            disabledTile.disable();
            warning.clearHighlight();
            self.nextDisabledTile = nil;
        }
        
        // pick next disabled tile and display warning
        self.nextDisabledTile = game.randomEnabledTile();
        if let tile = self.nextDisabledTile {
            tile.markedForDisable = true;
            warning.highlightTile(tile, texture: SKTexture(imageNamed: "CubeDarkGray"));
        }
    }
    
}
