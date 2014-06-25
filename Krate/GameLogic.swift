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
    
    // keeps track of succesful color matched tiles as the player tries to clear a group
    var colorMatchedTiles:Tile[] = [];
    
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

            let tile = Tile(tileWidth: tileWidth, tileHeight: tileHeight, position: position, row: rowCounter, column: colCounter);
            
            
            tileMatrix.grid.append(tile);
            world.canvas.addChild(tile.sprite);

            colCounter = colCounter == tileColCount - 1 ? 0 : colCounter + 1;
            
            if index % tileColCount == 0 {
                rowCounter++;
            }
        }
    }
    
    // the player is attempting to clear out some tiles
    func attemptTileClear(startingTile:Tile) {
        // start building our color matched tile array - starting with the initial tile
        self.colorMatchedTiles.append(startingTile);
        
        // start the recursive hunt for matching tiles
        checkAdjacentTiles(startingTile);
        
        // TODO: Do something with results!
        
        // reset our matched list
        self.colorMatchedTiles = [];
    }
    
    func checkAdjacentTiles(startingTile:Tile) {
        var adjacentTiles:Tile[] = [];
        let belowRow = startingTile.row - 1;
        let aboveRow = startingTile.row + 1;
        let leftCol = startingTile.column - 1;
        let rightCol = startingTile.column + 1;
        
        if belowRow >= 0 {
            adjacentTiles.append(game.tileMatrix[belowRow, startingTile.column]);
        }
        
        if aboveRow < tileColCount {
            adjacentTiles.append(game.tileMatrix[aboveRow, startingTile.column]);
        }
        
        if leftCol >= 0 {
            adjacentTiles.append(game.tileMatrix[startingTile.row, leftCol]);
        }
        
        if rightCol < tileRowCount {
            adjacentTiles.append(game.tileMatrix[startingTile.row, rightCol]);
        }
        
        for tile in adjacentTiles {
            if (tile.sprite.color == startingTile.sprite.color) {
                // they're the same color!  Make sure we haven't already matched this new tile:
                var tileIsAlreadyMatched = self.colorMatchedTiles.filter { $0 === tile }.count;
                // if it's not already in the collection, add it!
                if tileIsAlreadyMatched == 0 {
                    self.colorMatchedTiles.append(tile);
                    checkAdjacentTiles(tile); // recursively check this tile's adjacent tiles
                }
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