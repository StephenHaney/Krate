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
    var currentScene:SKScene?;
    
    let events = EventManager();
    let sounds = SoundManager();
    
    let hud = Hud();
    let world = World();
    let score = ScoreKeeper();
    let tileRowCount = 5;
    let tileColCount = 5;
    
    let highlight = TileHighlight();
    let warning = TileHighlight();
    
    var tileWidth:Int = 0;
    var tileHeight:Int = 0;
    
    var performingIntro = false;
    
    var possibleColors:SKTexture[];
    var upcomingColors:SKTexture[] = [];
    var tileMatrix:TileMatrix;
    
    var filledTileCount = 0;
    var turnCount = 0;
    var suggestedTile:Tile?;
    var nextDisabledTile:Tile?;
    
    // keeps track of succesful color matched tiles as the player tries to clear a group
    var colorMatchedTiles:Tile[] = [];
    
    init() {
        tileMatrix = TileMatrix(rows: tileRowCount, columns: tileColCount);
        
        possibleColors = [
            SKTexture(imageNamed: "CubeBlue"),
            SKTexture(imageNamed: "CubePurple"),
            SKTexture(imageNamed: "CubeGreen"),
            SKTexture(imageNamed: "CubeRed"),
            SKTexture(imageNamed: "CubeYellow")
        ];
        initColors();
        
        // every X seconds we want to black out another tile
        let blackoutSequence = SKAction.sequence([SKAction.waitForDuration(7), SKAction.runBlock({ self.pickDisabledTile(); })]);
        let blackoutTimer = SKAction.repeatActionForever(blackoutSequence);
        world.canvas.runAction(blackoutTimer);
        
        world.intro();
    }
    
    func buildTiles() {
        /* build and place tiles */
        let tileCount = tileRowCount * tileColCount;
        var rowCounter = 0;
        var colCounter = 0;

        for index in 1...tileCount {
            let size = CGSize(width: tileWidth, height: tileHeight);
            let positionX = (tileHeight * colCounter) + (tileWidth / 2);
            let positionY = (tileWidth * rowCounter) + (tileHeight / 2);
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
            self.events.trigger("tiles-cleared");
            for tile in self.colorMatchedTiles {
                tile.beenTapped = false;
                tile.sprite.texture = SKTexture(imageNamed: "CubeWhite");
                filledTileCount--;
            }

            world.shakeCamera(Float(self.colorMatchedTiles.count) * 0.06);
        }
        
        // if it's 4 or more, clear a black tile
        if (self.colorMatchedTiles.count > 3) {
            if let disabledTile = randomDisabledTile() {
                disabledTile.enable();
            }
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
    
    // fill in the upcoming colors for the first time
    func initColors() {
        for i in 0...3 {
            let colorIndex:Int = Int(arc4random_uniform(UInt32(possibleColors.count)));
            upcomingColors.append(possibleColors[colorIndex]);
        }
    }
    
    // pick a new color to tack on to the list!
    func pickNextColor() {
        let colorIndex:Int = Int(arc4random_uniform(UInt32(possibleColors.count)));
        
        upcomingColors.removeAtIndex(0);
        upcomingColors.append(possibleColors[colorIndex]);
        
        game.events.trigger("upcoming-colors-changed");
    }
    
    func informGameOver() {
        let transition = SKTransition.doorwayWithDuration(2.5);
        
        let gameOverScene = GameOverScene(size: CGSize(width: 320, height: 320));
        gameOverScene.scaleMode = SKSceneScaleMode.AspectFit;
        game.gameScene!.view.presentScene(gameOverScene, transition: transition);
    }
    
    func informTileFilled(tile:Tile) {
        filledTileCount++;
        
        if (filledTileCount == 25) {
            // game over!
            self.informGameOver();
        }
        else
        {
            // shake the camera
            world.shakeCamera(0.12);
        }
    }
    
    func informTurnPerformed(tile:Tile) {
        // pick the next color!
        game.pickNextColor();
        turnCount++;
        
        // starting with the second turn, every fifth turn we want to assign a 'suggested' spot
        if (turnCount + 2) % 5 == 0 {
            pickSuggestedTile();
        }
        else {
            // check if this is fulfilling a suggested spot, or ignoring one
            if self.suggestedTile {
                highlight.clearHighlight();
                
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
        self.suggestedTile!.disable();
    }
    
    func succesfulSuggestedTile() {
        // write bonus for succesfully placing a suggested tile
    }
    
    func pickSuggestedTile() {
        let possibleSuggestedTile = randomBlankTile();

        if let tile = possibleSuggestedTile {
            suggestedTile = tile;
            highlight.highlightTile(suggestedTile!, texture: game.upcomingColors[0]);
        }
    }
    
    func pickDisabledTile() {
        // disable the tile! (if there's one marked for it)
        if let disabledTile = self.nextDisabledTile {
            disabledTile.disable();
            warning.clearHighlight();
        }
        
        // pick next disabled tile and display warning
        self.nextDisabledTile = randomEnabledTile();
        if let tile = self.nextDisabledTile {
            warning.highlightTile(tile, texture: SKTexture(imageNamed: "CubeDarkGray"));
        }
    }
    
    // returns a gray tile
    // note that this won't return a tile if it's already marked for disable or suggested
    func randomBlankTile() -> Tile? {
        let blankTiles = game.tileMatrix.grid.filter ({
            $0.beenTapped == false &&
            self.nextDisabledTile !== $0 &&
            self.suggestedTile !== $0
        });
        
        if (blankTiles.count > 0) {
            let randomIndex = game.randomInt(blankTiles.count);
        
            return blankTiles[randomIndex];
        }

        return nil;
    }
    
    // returns a tile that hasn't been blacked out (but includes user colored tiles)
    // note that this won't return a tile if it's already marked for disable or suggested
    func randomEnabledTile() -> Tile? {
        let enabledTiles = game.tileMatrix.grid.filter {
            $0.blackedOut == false &&
            self.nextDisabledTile !== $0 &&
            self.suggestedTile !== $0
        };
        
        if enabledTiles.count > 0 {
            let randomIndex = game.randomInt(enabledTiles.count);
            
            return enabledTiles[randomIndex];
        }
        
        return nil;
    }
    
    // returns a tile that IS blacked out
    func randomDisabledTile() -> Tile? {
        let disabledTiles = game.tileMatrix.grid.filter {
            $0.blackedOut == true
        };
        
        if disabledTiles.count > 0 {
            let randomIndex = game.randomInt(disabledTiles.count);
            
            return disabledTiles[randomIndex];
        }
        
        return nil;
    }
    
    
    
    func randomInt(maxValue:Int) -> Int {
        return Int(arc4random_uniform(UInt32(maxValue)));
    }
    
    func randomFloat(maxValue:Float) -> Float {
        return Float(arc4random_uniform(UInt32(maxValue)));
    }
}