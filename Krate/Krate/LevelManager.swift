//
//  LevelManager class and Level struct
//  Krate
//
//  Created by Stephen Haney on 6/14/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import SpriteKit

class LevelManager {
    
    let levels:[Level];
    
    var currentLevelIndex = 0;
    
    var currentLevel:Level {
        get {
            return self.levels[self.currentLevelIndex];
        }
    }
    
    init() {
        self.levels = [
            Level(blackoutCount: 1, blackoutTimer: 7, scoreMultiplier: 1, experienceRequired: 45),          // 1
            Level(blackoutCount: 1, blackoutTimer: 6.7, scoreMultiplier: 1.5, experienceRequired: 55),      // 2
            Level(blackoutCount: 1, blackoutTimer: 6.4, scoreMultiplier: 2, experienceRequired: 75),      // 3
            Level(blackoutCount: 1, blackoutTimer: 6.1, scoreMultiplier: 2.5, experienceRequired: 100),     // 4
            Level(blackoutCount: 2, blackoutTimer: 11.6, scoreMultiplier: 3.5, experienceRequired: 100),       // 5
            Level(blackoutCount: 2, blackoutTimer: 11, scoreMultiplier: 4.5, experienceRequired: 100),       // 6
            Level(blackoutCount: 2, blackoutTimer: 10.4, scoreMultiplier: 5.5, experienceRequired: 100),       // 7
            Level(blackoutCount: 2, blackoutTimer: 9.8, scoreMultiplier: 6.5, experienceRequired: 125),      // 8
            Level(blackoutCount: 3, blackoutTimer: 13.8, scoreMultiplier: 8, experienceRequired: 175),    // 9
            Level(blackoutCount: 3, blackoutTimer: 12.9, scoreMultiplier: 9.5, experienceRequired: 175),         // 10
            Level(blackoutCount: 3, blackoutTimer: 12, scoreMultiplier: 11, experienceRequired: 175),     // 11
            Level(blackoutCount: 3, blackoutTimer: 11.1, scoreMultiplier: 12.5, experienceRequired: 225),      // 12
            Level(blackoutCount: 4, blackoutTimer: 13.6, scoreMultiplier: 14.5, experienceRequired: 300),     // 13
            Level(blackoutCount: 4, blackoutTimer: 12.4, scoreMultiplier: 16.5, experienceRequired: 300),       // 14
            Level(blackoutCount: 4, blackoutTimer: 11.2, scoreMultiplier: 18.5, experienceRequired: 300),       // 15
            Level(blackoutCount: 4, blackoutTimer: 10, scoreMultiplier: 25, experienceRequired: 1000),       // 16
        ];
    }
}


class Level {

    let blackoutCount:Int;
    
    let blackoutTimer:NSTimeInterval;
    
    let scoreMultiplier:Float;
    
    let experienceRequired:Int;
    
    init(blackoutCount:Int, blackoutTimer:NSTimeInterval, scoreMultiplier:Float, experienceRequired:Int) {
        self.blackoutCount = blackoutCount;
        self.blackoutTimer = blackoutTimer;
        self.scoreMultiplier = scoreMultiplier;
        self.experienceRequired = experienceRequired;
    }
    
}