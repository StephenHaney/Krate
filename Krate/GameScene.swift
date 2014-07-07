//
//  GameScene.swift
//  Krate
//
//  Created by Stephen Haney on 6/4/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        game.gameScene = self;
        game.currentScene = self;
        
        self.backgroundColor = UIColor.blackColor();
        let tileRowCount = 6;
        let tileColCount = 6;
                
        /* figure out dimensions */
        let screenWidth = Int(UIScreen.mainScreen().bounds.width);
        let screenHeight = Int(UIScreen.mainScreen().bounds.height);
        
        game.tileWidth = screenWidth / 2;
        game.tileHeight = game.tileWidth;
        
        let worldWidth = game.tileWidth * tileRowCount;
        let worldHeight = game.tileHeight * tileColCount;
        let hudHeight = screenHeight - (game.tileHeight * 2);
        
        /* place and size our world */
        let worldSize = CGSize(width: worldWidth, height: worldHeight);
        let worldPosition = CGPoint(x: screenWidth / 2, y: game.tileHeight * 2);

        game.world.canvas.size = worldSize;
        game.world.canvas.position = worldPosition;
        self.addChild(game.world.canvas);
        
        /* place the bottom hud */
        game.hud.sprite.size = CGSize(width: screenWidth, height: hudHeight);
        self.addChild(game.hud.sprite);
        
        game.buildTiles();
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location);
            let touchedTileArray = game.tileMatrix.grid.filter { $0.sprite === touchedNode };
            
            if touchedTileArray.count > 0
            {
                // if we touched a tile, fire its tap event
                touchedTileArray[0].onTap();
            }
            else if touchedNode === game.hud.sprite {
                // if we tapped the hud, fire its tap event
                game.hud.onTap();
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
