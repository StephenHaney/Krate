//
//  SoundManager.swift
//  Krate
//
//  Created by Stephen Haney on 7/6/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit;

class SoundManager {
    let tilePlaced = SKAction.playSoundFileNamed("tilePlaced.caf", waitForCompletion: false);
    
    let tilesCleared = SKAction.playSoundFileNamed("tilesCleared.caf", waitForCompletion: false);
    
    init() {}
    
    func setupListeners() {
        // when they place a tile
        game.events.listenTo("tile-placed", self.onTilePlaced);
        
        // when a tile group is cleared
        game.events.listenTo("tiles-cleared", self.onTilesCleared);
    }
    
    func onTilePlaced() {
        game.currentScene!.runAction(self.tilePlaced);
    }
    
    func onTilesCleared() {
        game.currentScene!.runAction(self.tilesCleared);
    }
}