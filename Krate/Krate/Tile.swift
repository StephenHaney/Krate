//
//  Tile.swift
//  Krate
//
//  Created by Stephen Haney on 6/14/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit

/* Tile class */
class Tile {
    let sprite = SKSpriteNode(imageNamed: "CubeWhite");
    var beenTapped = false;
    var disabled = false;
    var markedForDisable = false;
    let row:Int;
    let column:Int;
    
    init(tileWidth:Int, tileHeight:Int, position:CGPoint, row:Int, column:Int) {
        sprite.size = CGSize(width: tileWidth, height: tileHeight);
        sprite.position = position;
        sprite.color = UIColor.grayColor();
        sprite.zPosition = 10;
        self.row = row;
        self.column = column;
    }
    
    func disable() {
        self.sprite.alpha = 0.4;
        self.disabled = true;
        self.markedForDisable = false;
        
        if !self.beenTapped {
            self.beenTapped = true;
            game.informTileFilled(self);
        }
    }

    func enable() {
        self.sprite.alpha = 1;
        self.beenTapped = false;
        self.disabled = false;
        self.sprite.texture = SKTexture(imageNamed: "CubeWhite");
        game.filledTileCount--;
    }
    
    func onTap() {
        if (game.performingIntro == false && self.disabled == false) {
            if !self.beenTapped {
                // this tile is empty - give it the current game color
                sprite.texture = game.upcomingColors[0];
                beenTapped = true;
                game.informTileFilled(self);
                game.informTurnPerformed(self);
                game.events.trigger("tile-placed");
            }
            else {
                // this tile is filled, check to see if we can clear it
                game.attemptTileClear(self);
            }
        }
    }
    
    // show that a bad thing is about to happen to this tile!!
    func showWarning() {
        self.sprite.color = UIColor.blackColor();
        self.sprite.colorBlendFactor = 0.5;
    }
    
    func informSuggestedTile() {
    }
}



/* checkerboard code
if index % 2 == 0 {
    if rowCounter % 2 == 0 {
        tile.color = UIColor.blueColor();
    }
    else {
        tile.color = UIColor.lightGrayColor();
    }
}
else {
    if rowCounter % 2 == 0 {
        tile.color = UIColor.lightGrayColor();
    }
    else {
        tile.color = UIColor.blueColor();
    }
}*/