//
//  MealSummaryTests.swift
//  FetchMealsTests
//
//  Created by Kyle Ludwig on 5/27/24.
//

import XCTest
@testable import FetchMeals

final class MealSummaryTests: XCTestCase {
    func testDecodesMealSummaryResult() throws {
        // Given
        let json = #"""
        {
            "idMeal": "53049",
            "strMeal": "Apam balik",
            "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"
        }
        """#.data(using: .utf8)!
        
        // When
        let mealSummaryResult = try JSONDecoder().decode(MealSummary.Result.self, from: json)
        
        // Then
        XCTAssertEqual(
            mealSummaryResult.id,
            "53049",
            "MealSummary.Result id should match JSON value"
        )
        XCTAssertEqual(
            mealSummaryResult.title,
            "Apam Balik",
            "MealSummary.Result title should match JSON value with capitalization"
        )
        XCTAssertEqual(
            mealSummaryResult.thumbnailImageUrl,
            URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")!,
            "MealSummary.Result thumbnailImageUrl should match JSON value"
        )
    }
    
    func testDecodesMealSummary() throws {
        // Given
        let json = #"""
        {
            "meals": [
                {
                    "idMeal": "53049",
                    "strMeal": "Apam balik",
                    "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"
                }
            ]
        }
        """#.data(using: .utf8)!
        
        // When
        let mealSummary = try JSONDecoder().decode(MealSummary.self, from: json)
        
        // Then
        XCTAssertEqual(
            mealSummary.results.count,
            1,
            "MealSummary should contain Results"
        )
    }
}
