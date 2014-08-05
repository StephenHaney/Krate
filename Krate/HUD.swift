//
//  HUD.swift
//  Krate
//
//  Created by Stephen Haney on 6/14/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit

class Hud {
    let hudNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeZero);
    let upcomingSprites:SKSpriteNode[] = [
         SKSpriteNode(),
         SKSpriteNode(),
         SKSpriteNode(),
         SKSpriteNode()
    ];
    
    var scales:CGFloat[] = [];
    var positions:CGPoint[] = [];
    var alphas:CGFloat[] = [];

    var offsetIndex:Int = 0;
    
    init() {
        hudNode.zPosition = 500;
        
        for i in 0...3 {
            hudNode.addChild(self.upcomingSprites[i]);
        }
    }
    
    func setupListeners() {
        game.events.listenTo("upcoming-colors-changed", self.updateColors);
    }

    // called by GameScene with the screen sizes
    func initSizes(screenWidth:Int, hudHeight: Int) {
        let halfScreenWidth:Int = screenWidth / 2;
        let quarterScreenWidth:Int = screenWidth / 4;
        
        let heightOrigin = hudHeight / 2;
        let widthOriginBig = screenWidth / 4;
        let widthOriginSmall = screenWidth / 8;
        
        self.hudNode.position = CGPoint(x: halfScreenWidth, y: hudHeight / 2);
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
            self.upcomingSprites[i].zPosition = Float(abs(i - 3));
            self.upcomingSprites[i].position = self.positions[i];
            self.upcomingSprites[i].alpha = self.alphas[i];
            self.upcomingSprites[i].size = CGSize(width: halfScreenWidth, height: hudHeight);
            self.upcomingSprites[i].xScale = self.scales[i];
            self.upcomingSprites[i].yScale = self.scales[i];
            
            var colorIndex = i - 1;
            if colorIndex < 0 {
                colorIndex = game.upcomingColors.count - 1;
            }
            self.upcomingSprites[i].texture = game.upcomingColors[colorIndex];
        }
        
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
            
            let newZ:Float = self.upcomingSprites[adjustedIndex].zPosition + 1;
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
        self.upcomingSprites[offsetIndex].texture = game.upcomingColors[game.upcomingColors.count - 2];
        self.upcomingSprites[offsetIndex].zPosition = Float(0);
        self.upcomingSprites[offsetIndex].position = self.positions[arrayMax];
        self.upcomingSprites[offsetIndex].xScale = 0;
        self.upcomingSprites[offsetIndex].yScale = 0;
        self.upcomingSprites[offsetIndex].alpha = 0;
        
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