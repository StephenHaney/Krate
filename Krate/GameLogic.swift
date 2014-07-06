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
    var gameScene:GameScene?;
    let hud = Hud();
    let world = World();
    let tileRowCount = 6;
    let tileColCount = 6;
    
    var tileWidth:Int = 0;
    var tileHeight:Int = 0;
    
    var performingIntro = true;
    var score = 0;
    
    var possibleColors:SKTexture[];
    var currentColor = SKTexture(imageNamed: "CubeBlue");
    
    var tileMatrix:TileMatrix;
    
    var visibleRows:Int[];
    var visibleCols:Int[];
    var filledTileCount = 0;
    var turnCount = 0;
    var suggestedTile:Tile?;
    
    // keeps track of succesful color matched tiles as the player tries to clear a group
    var colorMatchedTiles:Tile[] = [];
    
    init() {
        tileMatrix = TileMatrix(rows: tileRowCount, columns: tileColCount);
        
        visibleRows = [2,3];
        visibleCols = [2,3];
        
        possibleColors = [
            SKTexture(imageNamed: "CubeBlue"),
            SKTexture(imageNamed: "CubePurple"),
            SKTexture(imageNamed: "CubeGreen"),
            SKTexture(imageNamed: "CubeRed"),
            SKTexture(imageNamed: "CubeYellow")
        ];
        pickColor();
        
        // every X seconds we want to black out another tile
        let blackoutSequence = SKAction.sequence([SKAction.waitForDuration(7), SKAction.runBlock({ self.pickDisabledTile(); })]);
        let blackoutTimer = SKAction.repeatActionForever(blackoutSequence);
        world.canvas.runAction(blackoutTimer);
        
        // perform the pre-game zoom in to the board
        world.pregameZoom();
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
        
        if (self.colorMatchedTiles.count > 2) {
            for tile in self.colorMatchedTiles {
                tile.beenTapped = false;
                tile.sprite.texture = SKTexture(imageNamed: "CubeWhite");
                filledTileCount--;
            }
            
            world.shakeCamera(0.1);
        }
        
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
            if (tile.blackedOut == false && tile.sprite.texture.isEqual(startingTile.sprite.texture)) {
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
    
    func informGameOver() {
        let transition = SKTransition.doorwayWithDuration(2.5);
        
        let gameOverScene = GameOverScene(size: CGSize(width: 320, height: 320));
        gameOverScene.scaleMode = SKSceneScaleMode.AspectFit;
        game.gameScene!.view.presentScene(gameOverScene, transition: transition);
    }
    
    func informTileFilled(tile:Tile) {
        filledTileCount++;
        turnCount++;

        println(filledTileCount);
        if (filledTileCount == 36) {
            // game over!
            self.informGameOver();
        }
        else
        {
            // shake the camera
            world.shakeCamera(0.03);
        
            self.checkForZoomChange();
        }
    }
    
    func informTurnPerformed(tile:Tile) {
        // starting with the second turn, every third turn we want to assign a 'suggested' spot
        if ((turnCount + 2) % 3 == 0) {
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
    
    func checkForZoomChange() {
        if (filledTileCount == 4 && world.zoomedOut == 0) {
            world.zoomOut(0.5);
            visibleRows = [1,2,3,4];
            visibleCols = [1,2,3,4];
        }
        else if (filledTileCount == 16 && world.zoomedOut == 1) {
            world.zoomOut(0.3333333334);
            visibleRows = [0,1,2,3,4,5];
            visibleCols = [0,1,2,3,4,5];
        }
    }
    
    func failedSuggestedTile() {
        // TODO: write penalty for missing a suggested tile
        self.suggestedTile!.disable();
        
        filledTileCount++;
        self.checkForZoomChange();
    }
    
    func succesfulSuggestedTile() {
        // write bonus for succesfully placing a suggested tile
        
        println("good job!");
    }
    
    func pickSuggestedTile() {
        let possibleSuggestedTile = randomVisibleBlankTile();

        if (possibleSuggestedTile.beenTapped == false) {
            suggestedTile = possibleSuggestedTile;
            suggestedTile!.informSuggestedTile();
        }
    }
    
    func pickDisabledTile() {
        let newDisabledTile = randomVisibleEnabledTile();
        
        if (newDisabledTile.beenTapped == false) {
            self.informTileFilled(newDisabledTile);
        }
        
        newDisabledTile.disable();
    }
    
    // returns a visible tile that is gray
    func randomVisibleBlankTile() -> Tile {
        var randomRowIndex = game.randomNum(visibleRows.count);
        var randomVisibleRow:Int = visibleRows[randomRowIndex];
        
        var randomColIndex = game.randomNum(visibleCols.count);
        var randomVisibleCol:Int = visibleCols[randomColIndex];
        
        let randomVisibleTile = game.tileMatrix[randomVisibleRow, randomVisibleCol];
        
        // keep trying until we get a blank tile recursively
        if (randomVisibleTile.beenTapped == true) {
            return randomVisibleBlankTile();
        }
        else {
            return randomVisibleTile;
        }
    }
    
    // returns a visible tile that hasn't been blacked out (but includes user colored tiles)
    func randomVisibleEnabledTile() -> Tile {
        var randomRowIndex = game.randomNum(visibleRows.count);
        var randomVisibleRow:Int = visibleRows[randomRowIndex];
        
        var randomColIndex = game.randomNum(visibleCols.count);
        var randomVisibleCol:Int = visibleCols[randomColIndex];
        
        let randomVisibleTile = game.tileMatrix[randomVisibleRow, randomVisibleCol];
        
        // keep trying until we get a blank tile recursively
        if (randomVisibleTile.blackedOut == true) {
            return randomVisibleEnabledTile();
        }
        else {
            return randomVisibleTile;
        }
    }
    
    func randomNum(maxValue:Int) -> Int {
        return Int(arc4random_uniform(UInt32(maxValue)));
    }
}