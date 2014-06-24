//
//  Matrix.swift
//  Krate
//
//  Created by Stephen Haney on 6/17/14.
//  Copyright (c) 2014 Stephen Haney. All rights reserved.
//

import Foundation

struct TileMatrix {
    let rows: Int, columns: Int;
    var grid = Tile[]();
    
    init(rows: Int, columns: Int) {
        self.rows = rows;
        self.columns = columns;
    }
    
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Tile {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range");
            return grid[(row * columns) + column];
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range");
            grid[(row * columns) + column] = newValue;
        }
    }
}