//
//  GameLogic.swift
//  Krate
//
//  Created by Stephen Haney on 6/15/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit
import Darwin

class GameLogic {
    let hud = Hud();
    let world = World();
    let tileRowCount = 6;
    let tileColCount = 6;
    
    var tileWidth:Int = 0;
    var tileHeight:Int = 0;
    
    var score = 0;
    
    var possibleColors:UIColor[];
    var currentColor = UIColor.blueColor();
    
    var tileMatrix:TileMatrix;
    
    var visibleRows:Int[];
    var visibleCols:Int[];
    var filledTileCount = 0;
    var suggestedTile:Tile?;
    
    init() {
        tileMatrix = TileMatrix(rows: tileRowCount, columns: tileColCount);
        
        visibleRows = [2,3];
        visibleCols = [2,3];
        
        possibleColors = [UIColor.blueColor(), UIColor.brownColor(), UIColor.greenColor(), UIColor.magentaColor(), UIColor.purpleColor()];
        pickColor();
    }
    
    func buildTiles() {
        /* build and place tiles */
        let tileCount = tileRowCount * tileColCount;
        var rowPlacement = -tileRowCount / 2;
        var colPlacement = -tileColCount / 2;
        var rowCounter = 0;
        var colCounter = 0;

        for index in 1...tileCount {
            let anchorPoint = CGPoint(x: 0, y: 0);
            let size = CGSize(width: tileWidth, height: tileHeight);
            let positionX = (tileHeight * colPlacement) + (tileHeight * colCounter);
            let positionY = (tileWidth * rowPlacement) + (tileWidth * rowCounter);
            let position = CGPoint(x: positionX, y: positionY);

            let tile = Tile(tileWidth: tileWidth, tileHeight: tileHeight, position: position);

            tileMatrix.grid.append(tile);
            world.canvas.addChild(tile.sprite);

            colCounter = colCounter == tileColCount - 1 ? 0 : colCounter + 1;
            
            if index % tileColCount == 0 {
                rowCounter++;
            }
        }
    }
    
    func pickColor() {
        let colorIndex:Int = Int(arc4random_uniform(UInt32(possibleColors.count)));
        currentColor = possibleColors[colorIndex];
        hud.informOfNewColor(currentColor);
    }
    
    func informTileFilled(tile:Tile) {
        filledTileCount++;
        
        if (filledTileCount == 4) {
            world.zoomOut(0.5);
            visibleRows = [1,2,3,4];
            visibleCols = [1,2,3,4];
        }
        else if (filledTileCount == 16) {
            world.zoomOut(0.3333333334);
            visibleRows = [0,1,2,3,4,5];
            visibleCols = [0,1,2,3,4,5];
        }
        
        // starting with the second turn, every third turn we want to assign a 'suggested' spot
        if ((filledTileCount + 2) % 3 == 0) {
            pickSuggestedTile();
        }
        else {
            // check if this is fulfilling a suggested spot, or ignoring one
            if (self.suggestedTile) {
                if (self.suggestedTile === tile) {
                    succesfulSuggestedTile();
                }
                else {
                    failedSuggestedTile();
                }
            
                self.suggestedTile!.sprite.xScale = 1;
                self.suggestedTile!.sprite.yScale = 1;
                self.suggestedTile = nil;
            }
        }
    }
    
    func failedSuggestedTile() {
        // TODO: write penalty for missing a suggested tile
        self.suggestedTile!.sprite.alpha = 0;
        self.suggestedTile!.beenTapped = true;
        
        filledTileCount++;
    }
    
    func succesfulSuggestedTile() {
        // write bonus for succesfully placing a suggested tile
        
        println("good job!");
    }
    
    func pickSuggestedTile() {
        var randomRowIndex = Int(arc4random_uniform(UInt32(visibleRows.count)));
        var randomVisibleRow:Int = visibleRows[randomRowIndex];
        
        var randomColIndex = Int(arc4random_uniform(UInt32(visibleRows.count)));
        var randomVisibleCol:Int = visibleRows[randomRowIndex];
        
        let possibleSuggestedTile = game.tileMatrix[randomVisibleRow, randomVisibleCol];

        if (possibleSuggestedTile.beenTapped == false) {
            suggestedTile = possibleSuggestedTile;
            suggestedTile!.informSuggestedTile();
        }
    }
}