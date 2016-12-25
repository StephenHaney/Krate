















// hello




//   Stephen




// scroll down . . .






































































































// check out Jon Hopkins - Vessel as inspiration for the music for Krate.


































//
//  HUD.swift
//  Krate
//
//  Created by Stephen Haney on 6/14/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit

class Hud {
    let hudNode = SKSpriteNode();
    let upcomingSprites:[SKEmitterNode] = [
         SKEmitterNode(),
         SKEmitterNode(),
         SKEmitterNode(),
         SKEmitterNode()
    ];
    let powerBar = SKSpriteNode(color: UIColor.darkGrayColor(), size: CGSizeZero);
    let levelUpText = SKLabelNode(fontNamed: "Avenir-Black");
    
    var scales:[CGFloat] = [];
    var positions:[CGPoint] = [];
    var alphas:[CGFloat] = [];

    var offsetIndex:Int = 0;
    
    init() {
        hudNode.zPosition = 500;
        
        var particle:SKEmitterNode = SKEmitterNode();
        let particlePath = NSBundle.mainBundle().pathForResource("bokeh", ofType: "sks");
        
        for i in 0...3 {
            hudNode.addChild(self.upcomingSprites[i]);
            
            self.upcomingSprites[i] = NSKeyedUnarchiver.unarchiveObjectWithFile(particlePath!) as SKEmitterNode;
            self.upcomingSprites[i].particleColorSequence = nil;
            self.upcomingSprites[i].particleColorBlendFactor = 0.15;
            self.upcomingSprites[i].particleZPosition = 40;
            self.upcomingSprites[i].particleZPositionRange = 0;
            hudNode.addChild(self.upcomingSprites[i]);
        }
        
        hudNode.addChild(self.powerBar);
        hudNode.addChild(self.levelUpText);
    }
    
    func setupListeners() {
        game.events.listenTo("upcoming-colors-changed", self.updateColors);
        game.events.listenTo("level-up", self.levelChange);
    }

    // called by GameScene with the screen sizes
    func initSizes(screenWidth:Int, hudHeight: Int) {
        let halfScreenWidth:Int = screenWidth / 2;
        let quarterScreenWidth:Int = screenWidth / 4;
        
        let heightOrigin = hudHeight / 2;
        let widthOriginBig = screenWidth / 4;
        let widthOriginSmall = screenWidth / 8;
        
        self.hudNode.position = CGPoint(x: halfScreenWidth, y: screenWidth + hudHeight / 2);
        self.hudNode.size = CGSize(width: screenWidth, height: hudHeight);
        
        self.scales.append(CGFloat(1));
        self.scales.append(CGFloat(1));
        self.scales.append(CGFloat(0.575));
        self.scales.append(CGFloat(0.25));
        
        self.positions.append(CGPoint(x: 0, y: 0));
        self.positions.append(CGPoint(x: 0, y: 0))
        self.positions.append(CGPoint(x: widthOriginBig, y: 0));
        self.positions.append(CGPoint(x: widthOriginBig + widthOriginSmall, y: 0));
        
        self.alphas.append(CGFloat(0));
        self.alphas.append(CGFloat(1));
        self.alphas.append(CGFloat(0.75));
        self.alphas.append(CGFloat(0.45));
        
        // put the sprites into the initial arrangement:
        for i in 0...3 {
            self.upcomingSprites[i].zPosition = CGFloat(abs(i - 3));
            self.upcomingSprites[i].position = self.positions[i];
            self.upcomingSprites[i].alpha = self.alphas[i];
            self.upcomingSprites[i].particlePositionRange = CGVector(dx: halfScreenWidth, dy: halfScreenWidth);
            self.upcomingSprites[i].xScale = self.scales[i];
            self.upcomingSprites[i].yScale = self.scales[i];
            self.upcomingSprites[i].particleScale = 0.5;
            self.upcomingSprites[i].particleBirthRate = 500;
            self.upcomingSprites[i].particleLifetime = 2;
            
            var colorIndex = i - 1;
            if colorIndex < 0 {
                colorIndex = game.upcomingColors.count - 1;
            }
            self.upcomingSprites[i].particleTexture = game.upcomingColors[colorIndex];
        }
        
        // place the power bar
        let powerBarHeight = hudHeight / 6;
        let powerBarPosY = hudHeight / 2 - powerBarHeight;
        
        self.powerBar.anchorPoint = CGPoint(x: 0, y: 0);
        self.powerBar.size = CGSize(width: 0, height: powerBarHeight);
        self.powerBar.position = CGPoint(x: -halfScreenWidth, y: powerBarPosY);
        self.powerBar.zPosition = 50;
        
        // place the level up text
        self.levelUpText.position = CGPointZero;
        self.levelUpText.alpha = 0;
        self.levelUpText.zPosition = -5;
    }
    
    // triggered via events when the player levels up!
    func levelChange() {
        let levelNumber = game.levelManager.currentLevelIndex + 1;
        self.levelUpText.text = "Welcome to Level \(levelNumber)!!!";
        self.levelUpText.zPosition = 100;
        
        let fadeSeq = SKAction.sequence([
            SKAction.fadeAlphaTo(1, duration: 0.2),
            SKAction.waitForDuration(1),
            SKAction.fadeAlphaTo(0, duration: 0.2)
        ]);
        
        self.levelUpText.runAction(fadeSeq, completion: {
            self.levelUpText.zPosition = -5;
        });
    }

    func doneWithPrismatic() {
        var currentSpriteIndex = 1 + self.offsetIndex;
        let arrayCount = self.upcomingSprites.count;
        let arrayMax = arrayCount - 1;
        
        if (currentSpriteIndex > arrayMax) {
            currentSpriteIndex = currentSpriteIndex - arrayCount;
        }
        
        self.upcomingSprites[currentSpriteIndex].particleTexture = game.upcomingColors[0];
        self.upcomingSprites[currentSpriteIndex].resetSimulation();
    }
    
    func showPrismatic() {
        var currentSpriteIndex = 1 + self.offsetIndex;
        let arrayCount = self.upcomingSprites.count;
        let arrayMax = arrayCount - 1;
        
        if (currentSpriteIndex > arrayMax) {
            currentSpriteIndex = currentSpriteIndex - arrayCount;
        }
        
        self.upcomingSprites[currentSpriteIndex].particleTexture = game.prismaticTexture;
        self.upcomingSprites[currentSpriteIndex].resetSimulation();
    }
    
    // triggered when the next colors update
    func updateColors() {
        let arrayCount = self.upcomingSprites.count;
        let arrayMax = arrayCount - 1;
        
        // loop thru the first three, the fourth is done manually
        for i in 1...arrayMax {
            var adjustedIndex = self.offsetIndex + i;
            
            if (adjustedIndex > arrayMax) {
                // adjust back to 0 if we're over the array size
                adjustedIndex = adjustedIndex - arrayCount;
            }
            
            let newZ:CGFloat = self.upcomingSprites[adjustedIndex].zPosition + 1;
            self.upcomingSprites[adjustedIndex].zPosition = newZ;
            
            let nextSpot = i - 1;
            let moveGroup = SKAction.group([
                SKAction.moveTo(self.positions[nextSpot], duration: 0.125),
                SKAction.scaleTo(self.scales[nextSpot], duration: 0.125),
                SKAction.fadeAlphaTo(self.alphas[nextSpot], duration: 0.125)
            ]);
            
            self.upcomingSprites[adjustedIndex].runAction(moveGroup, completion: {
            });
        }
        
        // reset negative tile to fourth spot and animate it in
        self.upcomingSprites[offsetIndex].particleTexture = game.upcomingColors[game.upcomingColors.count - 2];
        self.upcomingSprites[offsetIndex].zPosition = CGFloat(0);
        self.upcomingSprites[offsetIndex].position = self.positions[arrayMax];
        self.upcomingSprites[offsetIndex].xScale = 0;
        self.upcomingSprites[offsetIndex].yScale = 0;
        self.upcomingSprites[offsetIndex].alpha = 0;
        self.upcomingSprites[offsetIndex].resetSimulation();
        
        let moveGroup = SKAction.group([
            SKAction.scaleTo(self.scales[arrayMax], duration: 0.125),
            SKAction.fadeAlphaTo(self.alphas[arrayMax], duration: 0.125)
        ]);
        
        self.upcomingSprites[offsetIndex].runAction(moveGroup);
        
        
        self.offsetIndex++;
        if (self.offsetIndex > arrayMax) {
            self.offsetIndex = 0;
        }
    }
}