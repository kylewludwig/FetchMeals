//
//  MealCategoryTests.swift
//  FetchMealsTests
//
//  Created by Kyle Ludwig on 5/26/24.
//

import XCTest
@testable import FetchMeals

final class MealCategoryTests: XCTestCase {
    func testDecodesMealCategoryResult() throws {
        // Given
        let json = #"""
        {
            "idCategory": "1",
            "strCategory": "beef",
            "strCategoryDescription": "Beef is the culinary name for meat from cattle, particularly skeletal muscle. Humans have been eating beef since prehistoric times.[1] Beef is a source of high-quality protein and essential nutrients.[2]",
            "strCategoryThumb": "https://www.themealdb.com/images/category/beef.png"
        }
        """#.data(using: .utf8)!
        
        // When
        let mealCategoryResult = try JSONDecoder().decode(MealCategory.Result.self, from: json)
        
        // Then
        XCTAssertEqual(
            mealCategoryResult.id,
            "1",
            "MealCategory.Result id should match JSON value"
        )
        XCTAssertEqual(
            mealCategoryResult.title,
            "Beef",
            "MealCategory.Result title should match JSON value with capitalization"
        )
        XCTAssertEqual(
            mealCategoryResult.description,
            "Beef is the culinary name for meat from cattle, particularly skeletal muscle. Humans have been eating beef since prehistoric times.[1] Beef is a source of high-quality protein and essential nutrients.[2]",
            "MealCategory.Result description should match JSON value"
        )
        XCTAssertEqual(
            mealCategoryResult.thumbnailImageUrl,
            URL(string: "https://www.themealdb.com/images/category/beef.png")!,
            "MealCategory.Result thumbnailImageUrl should match JSON value"
        )
    }
    
    func testDecodesMealCategory() throws {
        // Given
        let json = #"""
        {
            "categories": [
                {
                    "idCategory": "1",
                    "strCategory": "Beef",
                    "strCategoryDescription": "Beef is the culinary name for meat from cattle, particularly skeletal muscle. Humans have been eating beef since prehistoric times.[1] Beef is a source of high-quality protein and essential nutrients.[2]",
                    "strCategoryThumb": "https://www.themealdb.com/images/category/beef.png"
                }
            ]
        }
        """#.data(using: .utf8)!
        
        // When
        let mealCategory = try JSONDecoder().decode(MealCategory.self, from: json)
        
        // Then
        XCTAssertEqual(
            mealCategory.results.count,
            1,
            "MealCategory should contain Results"
        )
    }
}
