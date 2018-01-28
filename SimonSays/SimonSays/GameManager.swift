//
//  GameStateManager.swift
//  SimonSays
//
//  Created by Poonam Hattangady on 1/27/18.
//  Copyright © 2018 Poonam Hattangady. All rights reserved.
//

import Foundation

class GameManager {
    
    var gameState = GameState()
    var nextIndexToCheck = 0
    
    // Game can only move to next level if:
    // - game hasn't begun
    // - current level has succeeded
    // GameState is updated when level increments
    // - level increments
    // - new random number added to sequence
    func startNextLevel() {
        if (gameState.status != .notStarted && gameState.status != .levelPassed) {
            return
        }

        nextIndexToCheck = 0
        gameState.level += 1
        gameState.status = .playingLevel
        gameState.sequence.append(Int(arc4random_uniform(4)))
    }
    
    // Checks the player's input
    // If wrong, level ends
    // If right, and more plays are left, keep waiting for player input
    // If right, and no more plays left, level has succeeded and Gamestate score is updated
    func checkAnswer(answer: Int) {
        if (nextIndexToCheck >= gameState.sequence.count || gameState.status != .playingLevel) {
            return
        }
        
        if gameState.sequence[nextIndexToCheck] == answer {
            // Answer is correct
            nextIndexToCheck += 1
            
            // Has game ended?
            if nextIndexToCheck >= gameState.sequence.count {
                gameState.score += 1
                gameState.status = .levelPassed
            }
        }
        else {
            // Answer is wrong. end the game.
            gameState.status = .levelFailed
        }
    }
}
