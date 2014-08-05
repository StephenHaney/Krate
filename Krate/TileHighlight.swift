//
//  TileHighlight.swift
//  Krate
//
//  Created by Stephen Haney on 7/6/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit

class TileHighlight {
    let particleGroup = SKNode();
    let particleNodeTop:SKEmitterNode;
    let particleNodeBottom:SKEmitterNode;
    let particleNodeLeft:SKEmitterNode;
    let particleNodeRight:SKEmitterNode;
    var currentTile:Tile?
    
    init() {
        let particlePath = NSBundle.mainBundle().pathForResource("TileHighlight", ofType: "sks");
        particleNodeTop = NSKeyedUnarchiver.unarchiveObjectWithFile(particlePath) as SKEmitterNode;
        particleNodeBottom = NSKeyedUnarchiver.unarchiveObjectWithFile(particlePath) as SKEmitterNode;
        particleNodeLeft = NSKeyedUnarchiver.unarchiveObjectWithFile(particlePath) as SKEmitterNode;
        particleNodeRight = NSKeyedUnarchiver.unarchiveObjectWithFile(particlePath) as SKEmitterNode;
        
        particleGroup.addChild(particleNodeTop);
        particleGroup.addChild(particleNodeBottom);
        particleGroup.addChild(particleNodeLeft);
        particleGroup.addChild(particleNodeRight);
        
    }
    
    func highlightTile(tile:Tile, texture:SKTexture) {
        self.currentTile = tile;
        tile.sprite.zPosition = 20;
        
        let tileHeight = tile.sprite.size.height;
        let tileWidth = tile.sprite.size.width;
        
        let tilePosX = tile.sprite.position.x;
        let tilePosY = tile.sprite.position.y;
        
        let tile50PercentHeight = tileHeight / 2;
        let tile50PercentWidth = tileWidth / 2;
        let tile10PercentHeight = CGFloat(tileHeight / 30);
        let tile10PercentWidth = CGFloat(tileWidth / 30);
        
        particleNodeTop.particlePosition = CGPoint(x: tilePosX, y: tilePosY - tile50PercentHeight);
        particleNodeTop.particlePositionRange = CGVectorMake(tile.sprite.size.width, tile10PercentHeight);
        particleNodeTop.targetNode = tile.sprite;
        particleNodeTop.particleTexture = texture;
        particleNodeTop.particleColorSequence = nil;
        particleNodeTop.particleColorBlendFactor = 0.15;
        particleNodeTop.particleZPosition = 40;
        particleNodeTop.particleZPositionRange = 0;
        
        particleNodeBottom.particlePosition = CGPoint(x: tilePosX, y: tilePosY + tile50PercentHeight);
        particleNodeBottom.particlePositionRange = CGVectorMake(tile.sprite.size.width, tile10PercentHeight);
        particleNodeBottom.targetNode = tile.sprite;
        particleNodeBottom.particleTexture = texture;
        particleNodeBottom.particleColorSequence = nil;
        particleNodeBottom.particleColorBlendFactor = 0.15;
        particleNodeBottom.particleZPosition = 40;
        particleNodeBottom.particleZPositionRange = 0;
        
        particleNodeRight.particlePosition = CGPoint(x: tilePosX - tile50PercentWidth, y: tilePosY);
        particleNodeRight.particlePositionRange = CGVectorMake(tile10PercentWidth, tile.sprite.size.height);
        particleNodeRight.targetNode = tile.sprite;
        particleNodeRight.particleTexture = texture;
        particleNodeRight.particleColorSequence = nil;
        particleNodeRight.particleColorBlendFactor = 0.15;
        particleNodeRight.particleZPosition = 40;
        particleNodeRight.particleZPositionRange = 0;
        
        particleNodeLeft.particlePosition = CGPoint(x: tilePosX + tile50PercentWidth, y: tilePosY);
        particleNodeLeft.particlePositionRange = CGVectorMake(tile10PercentWidth, tile.sprite.size.height);
        particleNodeLeft.targetNode = tile.sprite;
        particleNodeLeft.particleTexture = texture;
        particleNodeLeft.particleColorSequence = nil;
        particleNodeLeft.particleColorBlendFactor = 0.15;
        particleNodeLeft.particleZPosition = 40;
        particleNodeLeft.particleZPositionRange = 0;
        
        game.world.canvas.addChild(particleGroup);
    }
    
    func clearHighlight() {
        particleGroup.removeFromParent();
        
        if (self.currentTile !== nil) {
            self.currentTile!.sprite.zPosition = 10;
        }
    }
}
