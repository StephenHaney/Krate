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
    let sprite = SKSpriteNode();
    var color:UIColor?;
    var beenTapped = false;
    let row:Int;
    let column:Int;
    
    init(tileWidth:Int, tileHeight:Int, position:CGPoint, row:Int, column:Int) {
        sprite.anchorPoint = CGPoint(x: 0, y: 0);
        sprite.size = CGSize(width: tileWidth, height: tileHeight);
        sprite.position = position;
        sprite.color = UIColor.grayColor();
        self.row = row;
        self.column = column;
    }
    
    func onTap() {
        if (beenTapped === false) {
            // this tile is empty - give it the current game color
            sprite.color = game.currentColor;
            game.pickColor();
            beenTapped = true;
            game.informTileFilled(self);
        }
        else {
            // this tile is filled, check to see if we can clear it
            game.attemptTileClear(self);
        }
    }
    
    func setColor(newColor:UIColor) {
        self.color = newColor;
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