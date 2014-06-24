//
//  HUD.swift
//  Krate
//
//  Created by Stephen Haney on 6/14/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit

class Hud {
    let sprite = SKSpriteNode();
    
    init() {
        sprite.position = CGPoint(x: 0, y: 0);
        sprite.anchorPoint = CGPoint(x: 0, y: 0);
        sprite.color = UIColor.redColor();
    }
    
    func onTap() {
    }
    
    func informOfNewColor(newColor: UIColor) {
        sprite.color = newColor;
    }
}