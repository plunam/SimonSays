//
//  GameManagerTests.swift
//  SimonSaysTests
//
//  Created by Poonam Hattangady on 1/27/18.
//  Copyright © 2018 Poonam Hattangady. All rights reserved.
//

import XCTest

class GameManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Creating GameManager
    func testCreateGameManager() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let gm = GameManager()
        XCTAssert(gm.gameState.level == 0)
        XCTAssert(gm.gameState.score == 0)
        XCTAssert(gm.gameState.sequence.count == 0)
        XCTAssert(gm.gameState.status == .notStarted)
    }
    
    // MARK: Testing start next level
    func testStartNextLevelWhenLevel1Succeeded() {
        let gm = GameManager()
        gm.startNextLevel()
        gm.checkAnswer(answer: gm.gameState.sequence[0])
        let oldSequence = gm.gameState.sequence
        gm.startNextLevel()
        XCTAssert(gm.gameState.level == 2, "Advance to level 2")
        XCTAssert(gm.gameState.sequence.count == 2, "Sequence should be of length 2")
        XCTAssert(gm.gameState.sequence[0] == oldSequence[0], "Sequence[0] should be unchanged")
        XCTAssert(gm.gameState.status == .playingLevel, "We are now playing a level")
        XCTAssert(gm.nextIndexToCheck == 0, "Start checking answers at index 0")
    }

    func testStartNextLevelWhenLevelNSucceeded() {
        let gm = GameManager()
        gm.gameState.status = .levelPassed
        gm.gameState.level = 2
        gm.gameState.sequence = [1, 2]
        gm.startNextLevel()
        XCTAssert(gm.gameState.level == 3, "Advance to level 3")
        XCTAssert(gm.gameState.sequence.count == 3, "Sequence should be of length 3")
        XCTAssert(gm.gameState.sequence[0] == 1, "Sequence[0] should be unchanged")
        XCTAssert(gm.gameState.sequence[1] == 2, "Sequence[1] should be unchanged")
        XCTAssert(gm.gameState.status == .playingLevel, "We are now playing a level")
    }

    func testStartNextLevelWhenLevelNFailed() {
        let gm = GameManager()
        gm.gameState.status = .levelFailed
        gm.gameState.level = 2
        gm.gameState.sequence = [1, 2]
        gm.startNextLevel()
        XCTAssert(gm.gameState.level == 2, "Don't advance to level 3 when level 2 failed")
        XCTAssert(gm.gameState.sequence.count == 2, "Sequence should remain of length 2")
        XCTAssert(gm.gameState.status == .levelFailed, "Level should stay failed because we haven't moved to a new level")
    }
    
    func testStartNextLevelWhenLevelNPlaying() {
        let gm = GameManager()
        gm.gameState.status = .playingLevel
        gm.gameState.level = 2
        gm.gameState.sequence = [1, 2]
        gm.startNextLevel()
        XCTAssert(gm.gameState.level == 2, "Don't advance to level 3 when level 2 is still being played")
        XCTAssert(gm.gameState.sequence.count == 2, "Sequence should remain of length 2")
        XCTAssert(gm.gameState.status == .playingLevel, "Level should stay Playing because we haven't moved to a new level")
    }

    // MARK: Testing checkAnswer with correct answers
    func testCheckAnswerSequenceOfLength1() {
        let gm = GameManager()
        gm.startNextLevel()
        gm.checkAnswer(answer: gm.gameState.sequence[0])
        XCTAssert(gm.gameState.status == .levelPassed, "Level should be marked as passed when only sequence is answered correctly")
        XCTAssert(gm.gameState.score == 1, "Score should be 1 after first level is completed")
    }

    func testCheckCorrectAnswerAtStartOfSequence() {
        let gm = GameManager()
        gm.gameState.level = 3
        gm.gameState.score = 2
        gm.gameState.status = .playingLevel
        gm.nextIndexToCheck = 0
        gm.gameState.sequence = [1, 2, 3]
        
        gm.checkAnswer(answer: 1)
        XCTAssert(gm.gameState.level == 3, "Level hasn't ended yet")
        XCTAssert(gm.gameState.score == 2, "Level hasn't ended yet")
        XCTAssert(gm.gameState.status == .playingLevel, "Level hasn't ended yet")
    }
    
    func testCheckCorrectAnswerMiddleOfSequence() {
        let gm = GameManager()
        gm.gameState.level = 3
        gm.gameState.score = 2
        gm.gameState.status = .playingLevel
        gm.nextIndexToCheck = 1
        gm.gameState.sequence = [1, 2, 3]
        
        gm.checkAnswer(answer: 2)
        XCTAssert(gm.gameState.level == 3, "Level hasn't ended yet")
        XCTAssert(gm.gameState.score == 2, "Level hasn't ended yet")
        XCTAssert(gm.gameState.status == .playingLevel, "Level hasn't ended yet")
    }
    
    func testCheckCorrectAnswerEndOfSequence() {
        let gm = GameManager()
        gm.gameState.level = 3
        gm.gameState.score = 2
        gm.gameState.status = .playingLevel
        gm.nextIndexToCheck = 2
        gm.gameState.sequence = [1, 2, 3]
        
        gm.checkAnswer(answer: 3)
        XCTAssert(gm.gameState.level == 3, "Level has ended, but we haven't started a new level yet")
        XCTAssert(gm.gameState.score == 3, "Level has succeeded, so score should increase by 1")
        XCTAssert(gm.gameState.status == .levelPassed, "Level is passed")
    }


    // MARK: Testing checkAnswer with wrong answers
    func testWrongAnswerSequenceOfLength1() {
        let gm = GameManager()
        gm.startNextLevel()
        gm.checkAnswer(answer: gm.gameState.sequence[0] + 1)
        XCTAssert(gm.gameState.status == .levelFailed, "Level Failed")
        XCTAssert(gm.gameState.score == 0, "Score should be 0 if no level has succeeded")
    }
    
    func testCheckWrongAnswerAtStartOfSequence() {
        let gm = GameManager()
        gm.gameState.level = 3
        gm.gameState.score = 2
        gm.gameState.status = .playingLevel
        gm.nextIndexToCheck = 0
        gm.gameState.sequence = [1, 2, 3]
        
        gm.checkAnswer(answer: 2)
        XCTAssert(gm.gameState.level == 3, "Level has failed so level shouldn't change")
        XCTAssert(gm.gameState.score == 2, "Level has failed so score shouldn't change")
        XCTAssert(gm.gameState.status == .levelFailed, "Level is over")
    }

    func testCheckWrongAnswerMiddleOfSequence() {
        let gm = GameManager()
        gm.gameState.level = 3
        gm.gameState.score = 2
        gm.gameState.status = .playingLevel
        gm.nextIndexToCheck = 1
        gm.gameState.sequence = [1, 2, 3]
        
        gm.checkAnswer(answer: 3)
        XCTAssert(gm.gameState.level == 3, "Level has failed so level shouldn't change")
        XCTAssert(gm.gameState.score == 2, "Level has failed so score shouldn't change")
        XCTAssert(gm.gameState.status == .levelFailed, "Level is over")
    }

    func testCheckWrongAnswerEndOfSequence() {
        let gm = GameManager()
        gm.gameState.level = 3
        gm.gameState.score = 2
        gm.gameState.status = .playingLevel
        gm.nextIndexToCheck = 2
        gm.gameState.sequence = [1, 2, 3]
        
        gm.checkAnswer(answer: 1)
        XCTAssert(gm.gameState.level == 3, "Level has failed so level shouldn't change")
        XCTAssert(gm.gameState.score == 2, "Level has failed so score shouldn't change")
        XCTAssert(gm.gameState.status == .levelFailed, "Level is over")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
