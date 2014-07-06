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
    let row:Int;
    let column:Int;
    var blackedOut = false;
    
    init(tileWidth:Int, tileHeight:Int, position:CGPoint, row:Int, column:Int) {
        sprite.anchorPoint = CGPoint(x: 0, y: 0);
        sprite.size = CGSize(width: tileWidth, height: tileHeight);
        sprite.position = position;
        sprite.color = UIColor.grayColor();
        self.row = row;
        self.column = column;
    }
    
    func disable() {
        self.sprite.alpha = 0.2;
        self.beenTapped = true;
        self.blackedOut = true;
    }
    
    func enable() {
        self.sprite.alpha = 1;
        self.sprite.color = UIColor.grayColor();
        self.beenTapped = false;
        self.blackedOut = false;
    }
    
    func onTap() {
        if (game.performingIntro == false && self.blackedOut == false) {
            if (self.beenTapped == false) {
                // this tile is empty - give it the current game color
                sprite.texture = game.currentColor;
                game.pickColor();
                beenTapped = true;
                game.informTileFilled(self);
                game.informTurnPerformed(self);
            }
            else {
                // this tile is filled, check to see if we can clear it
                game.attemptTileClear(self);
            }
        }
    }
    
    func informSuggestedTile() {
        sprite.xScale = 0.9;
        sprite.yScale = 0.9;
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