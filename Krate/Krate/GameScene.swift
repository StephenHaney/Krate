//
//  GameScene.swift
//  Krate
//
//  Created by Stephen Haney on 9/20/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        game.gameScene = self;
        game.currentScene = self;
        
        self.backgroundColor = UIColor.blackColor();
        
        /* figure out dimensions */
        let screenWidth = Int(UIScreen.mainScreen().bounds.width);
        let screenHeight = Int(UIScreen.mainScreen().bounds.height);
        let screenCenterX = CGFloat(screenWidth) / 2;
        let screenCenterY = CGFloat(screenHeight) / 2;
        
        let worldWidth = screenWidth;
        let worldHeight = screenWidth;
        let hudHeight = screenHeight - worldHeight;
        
        /* place and size our world */
        let worldSize = CGSize(width: worldWidth, height: worldHeight);
        let worldPosX = screenCenterX;
        let worldPosY = screenCenterY + CGFloat(hudHeight) / 2;
        let worldPosition = CGPoint(x: worldPosX, y: worldPosY);
        
        game.world.canvas.size = worldSize;
        game.world.canvas.position = worldPosition;
        self.addChild(game.world.canvas);
        
        /* place the bottom hud */
        game.hud.initSizes(screenWidth, hudHeight: hudHeight);
        self.addChild(game.hud.hudNode);
        
        /* add the background */
        let background = SKSpriteNode(imageNamed: "Parchment");
        background.size = CGSize(width: screenWidth, height: screenHeight);
        background.position = CGPoint(x: screenCenterX, y: screenCenterY);
        self.addChild(background);
        
        let backgroundParticlePath = NSBundle.mainBundle().pathForResource("background", ofType: "sks")
        let backgroundParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(backgroundParticlePath!) as SKEmitterNode;
        
        backgroundParticle.targetNode = background;
        game.world.canvas.addChild(backgroundParticle);
        
        /* size and place the score keeper */
        game.score.sprite.size = CGSize(width: screenWidth, height: worldHeight / game.tileColCount);
        game.score.sprite.position = CGPoint(x: screenWidth / 2, y: 10);
        self.addChild(game.score.sprite);
        
        game.startGame();

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
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
