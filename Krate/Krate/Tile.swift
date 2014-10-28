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
    let sprite = SKSpriteNode(imageNamed: "TileBackground");
    var currentTexture = SKTexture(imageNamed: "CubeWhite");
    var beenTapped = false;
    var disabled = false;
    var markedForDisable = false;
    let row:Int;
    let column:Int;
    var particle:SKEmitterNode = SKEmitterNode();
    let clearParticle:SKEmitterNode = SKEmitterNode();
    
    init(tileWidth:Int, tileHeight:Int, position:CGPoint, row:Int, column:Int) {
        sprite.size = CGSize(width: tileWidth, height: tileHeight);
        sprite.position = position;
        sprite.zPosition = 10;
        self.row = row;
        self.column = column;
        
        let particlePath = NSBundle.mainBundle().pathForResource("bokeh", ofType: "sks")
        particle = NSKeyedUnarchiver.unarchiveObjectWithFile(particlePath!) as SKEmitterNode;
        
        particle.particlePosition = CGPoint(x: self.sprite.position.x, y: self.sprite.position.y);
        particle.particlePositionRange = CGVectorMake(self.sprite.size.width, self.sprite.size.height);
        particle.targetNode = self.sprite;
        particle.particleColorSequence = nil;
        particle.particleColorBlendFactor = 0.15;
        particle.particleZPosition = 40;
        particle.particleZPositionRange = 0;
        
        let clearParticlePath = NSBundle.mainBundle().pathForResource("clear", ofType: "sks")
        self.clearParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(clearParticlePath!) as SKEmitterNode;
        
        clearParticle.particlePosition = CGPoint(x: self.sprite.position.x, y: self.sprite.position.y);
        clearParticle.particlePositionRange = CGVectorMake(self.sprite.size.width, self.sprite.size.height);
        clearParticle.targetNode = self.sprite;
        clearParticle.particleZPosition = 80;
        clearParticle.particleZPositionRange = 0;
        clearParticle.numParticlesToEmit = 250;
        clearParticle.particleBirthRate = 0;
        game.world.canvas.addChild(clearParticle);
    }
    
    func clearAnimation() {
        self.clearParticle.resetSimulation();
        self.clearParticle.particleBirthRate = 250;
    }
    
    func startMainParticles() {
        self.particle.resetSimulation();
        game.world.canvas.addChild(self.particle);
    }
    
    func pauseMainParticles() {
        game.world.canvas.removeChildrenInArray([self.particle]);
    }
    
    func disable() {
        self.sprite.alpha = 0.1;
        self.disabled = true;
        self.markedForDisable = false;
        self.particle.alpha = 0.1;
        
        if !self.beenTapped {
            self.beenTapped = true;
            game.informTileFilled(self);
        }
    }

    func enable() {
        self.sprite.alpha = 1;
        self.beenTapped = false;
        self.disabled = false;
        self.currentTexture = SKTexture(imageNamed: "CubeWhite");
        game.filledTileCount--;
        self.pauseMainParticles();
    }
    
    func onTap() {
        if (game.performingIntro == false && self.disabled == false) {
            if !self.beenTapped {
                // this tile is empty - give it the current game color
                if (game.upcomingColors[0] === game.prismaticTexture) {
                    game.prismaticClear(self);
                    game.pickNextColor();
                }
                else {
                    self.currentTexture = game.upcomingColors[0];
                    beenTapped = true;
                    game.informTileFilled(self);
                    game.informTurnPerformed(self);
                    particle.particleTexture = self.currentTexture;
                    self.startMainParticles();
                    game.events.trigger("tile-placed");
                }
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