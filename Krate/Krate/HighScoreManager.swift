//
//  HighScores.swift
//  Krate
//
//  Created by Stephen Haney on 11/13/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import Foundation

class HighScoreManager {
    var scores:Array<HighScore> = [];
    
    init() {
        // load existing high scores or set up an empty array
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        let path = documentsDirectory.stringByAppendingPathComponent("HighScores.plist")
        
        let fileManager = NSFileManager.defaultManager()
        
        // check if file exists
        if !fileManager.fileExistsAtPath(path) {
            // create an empty file if it doesn't exist
            if let bundle = NSBundle.mainBundle().pathForResource("DefaultFile", ofType: "plist") {
                fileManager.copyItemAtPath(bundle, toPath: path, error:nil)
            }
        }
        
        if let rawData = NSData(contentsOfFile: path) {
            // do we get serialized data back from the attempted path?
            // if so, unarchive it into an AnyObject, and then convert to an array of HighScores, if possible
            var scoreArray: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
            self.scores = scoreArray as? [HighScore] ?? [];
        }
    }
    
    func save() {
        let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.scores);
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
        let documentsDirectory = paths.objectAtIndex(0) as NSString;
        let path = documentsDirectory.stringByAppendingPathComponent("HighScores.plist");
        
        saveData.writeToFile(path, atomically: true);
    }
    
    // returns a 0 based index rank for the new score, or -1 if it doesn't make the cut
    // note that I'm removing a limit for now, so everything should get a rank
    func addNewScore(newScore:Int) -> Int {
        let newHighScore = HighScore(score: newScore, dateOfScore: NSDate());
        
        for (index, highScore) in enumerate(self.scores) {
            if (highScore.score <= newScore) {
                
                self.scores.insert(newHighScore, atIndex: index);
                self.save();
                
                // return the 0 based rank of their new score!
                return index;
            }
        }
        
        // if we're here, this is the lowest score ever recorded
        self.scores.append(newHighScore);
        self.save();
        // return the index of the append
        return self.scores.count - 1;
    }
}

// inherit from NSCoding to make instances serializable
class HighScore: NSObject, NSCoding {
    let score:Int;
    let dateOfScore:NSDate;
    
    init(score:Int, dateOfScore:NSDate) {
        self.score = score;
        self.dateOfScore = dateOfScore;
    }
    
    required init(coder: NSCoder) {
        self.score = coder.decodeObjectForKey("score")! as Int;
        self.dateOfScore = coder.decodeObjectForKey("dateOfScore")! as NSDate;
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.score, forKey: "score")
        coder.encodeObject(self.dateOfScore, forKey: "dateOfScore")
    }
    
    func formattedDate() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd";
        
        return dateFormatter.stringFromDate(self.dateOfScore);
    }
    
    func formattedScore() -> String {
        let scoreStr = String(self.score);
        let leading0s = (game.score.defaultScoreText as NSString).substringFromIndex(countElements(scoreStr));
        
        return leading0s + scoreStr;
    }
}