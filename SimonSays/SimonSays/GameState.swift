//
//  GameState.swift
//  SimonSays
//
//  Created by Poonam Hattangady on 1/27/18.
//  Copyright © 2018 Poonam Hattangady. All rights reserved.
//

import Foundation

struct GameState {
    var level: Int = 0
    var score: Int = 0
    var sequence = [Int]()
    var status = GameStatus.notStarted
}
