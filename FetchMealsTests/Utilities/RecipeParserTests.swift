//
//  RecipeParserTests.swift
//  FetchMealsTests
//
//  Created by Kyle Ludwig on 5/27/24.
//

import Foundation

import XCTest
@testable import FetchMeals

final class RecipeParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInstructionsShouldNotContainNewlineCharacters() throws {
        // Given
        let instruction = "Add 2 eggs to a bowl.\nThen add 1/2 cup of flour to the bowl"
        
        // When
        let actualInstructions = RecipeParser.parseInstructions(instruction)
        
        // Then
        let expectedInstructions = [
            "Add 2 eggs to a bowl.",
            "Then add 1/2 cup of flour to the bowl."
        ]
        for (expected, actual) in zip(expectedInstructions, actualInstructions) {
            XCTAssertEqual(
                expected,
                actual,
                "Instructions should not contain newline characters"
            )
        }
    }
    
    func testInstructionsShouldNotContainCarriageReturnCharacters() throws {
        // Given
        let instruction = "Add 2 eggs to a bowl.\rThen add 1/2 cup of flour to the bowl"
        
        // When
        let actualInstructions = RecipeParser.parseInstructions(instruction)
        
        // Then
        let expectedInstructions = [
            "Add 2 eggs to a bowl.",
            "Then add 1/2 cup of flour to the bowl."
        ]
        for (expected, actual) in zip(expectedInstructions, actualInstructions) {
            XCTAssertEqual(
                expected,
                actual,
                "Instructions should not contain carriage return characters"
            )
        }
    }
    
    func testInstructionsShouldNotBeginOrEndWithNumbers() throws {
        // Given
        let instruction = "1. Add 2 eggs to a bowl. 2. Then add 1/2 cup of flour to the bowl"
        
        // When
        let actualInstructions = RecipeParser.parseInstructions(instruction)
        
        // Then
        let expectedInstructions = [
            "Add 2 eggs to a bowl.",
            "Then add 1/2 cup of flour to the bowl."
        ]
        for (expected, actual) in zip(expectedInstructions, actualInstructions) {
            XCTAssertEqual(
                expected,
                actual,
                "Instructions should not begin or end with numbers"
            )
        }
    }
    
    func testInstructionsShouldNotBeginOrEndWithWhitespace() throws {
        // Given
        let instruction = " Add 2 eggs to a bowl "
        
        // When
        let actualInstructions = RecipeParser.parseInstructions(instruction)
        
        // Then
        let expectedInstructions = [
            "Add 2 eggs to a bowl."
        ]
        for (expected, actual) in zip(expectedInstructions, actualInstructions) {
            XCTAssertEqual(
                expected,
                actual,
                "Instructions should not begin or end with whitespace"
            )
        }
    }
    
    func testInstructionsShouldNotContainEmptySteps() throws {
        // Given
        let instruction = " . Add 2 eggs to a bowl. . Then add 1/2 cup of flour to the bowl"
        
        // When
        let actualInstructions = RecipeParser.parseInstructions(instruction)
        
        // Then
        let expectedInstructions = [
            "Add 2 eggs to a bowl.",
            "Then add 1/2 cup of flour to the bowl."
        ]
        for (expected, actual) in zip(expectedInstructions, actualInstructions) {
            XCTAssertEqual(
                expected,
                actual,
                "Instructions should not contain empty steps"
            )
        }
    }
    
    func testInstructionsShouldNotContainStepsNumbers() throws {
        // Given
        let instruction = "1. Add 2 eggs to a bowl. Step 2. Then add 1/2 cup of flour to the bowl"
        
        // When
        let actualInstructions = RecipeParser.parseInstructions(instruction)
        
        // Then
        let expectedInstructions = [
            "Add 2 eggs to a bowl.",
            "Then add 1/2 cup of flour to the bowl."
        ]
        for (expected, actual) in zip(expectedInstructions, actualInstructions) {
            XCTAssertEqual(
                expected,
                actual,
                "Instructions should not contain empty steps"
            )
        }
    }
    
    func testInstructionStepsShouldEndWithPeriod() throws {
        // Given
        let instruction = "Add 2 eggs to a bowl"
        
        // When
        let actualInstructions = RecipeParser.parseInstructions(instruction)
        
        // Then
        let expectedInstructions = [
            "Add 2 eggs to a bowl."
        ]
        for (expected, actual) in zip(expectedInstructions, actualInstructions) {
            XCTAssertEqual(
                expected,
                actual,
                "Instructions should end with a period"
            )
        }
    }
}
