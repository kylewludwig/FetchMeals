//
//  MealDetailTests.swift
//  FetchMealsTests
//
//  Created by Kyle Ludwig on 5/27/24.
//

import XCTest
@testable import FetchMeals

final class MealDetailTests: XCTestCase {
    func testDecodesMealDetailResult() throws {
        // Given
        let json = #"""
        {
           "idMeal": "53049",
           "strMeal": "Apam balik",
           "strDrinkAlternate": null,
           "strCategory": "Dessert",
           "strArea": "Malaysian",
           "strInstructions": "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm. .",
           "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
           "strTags": null,
           "strYoutube": "https://www.youtube.com/watch?v=6R8ffRRJcrg",
           "strIngredient1": "Milk",
           "strIngredient2": "Oil",
           "strIngredient3": "Eggs",
           "strIngredient4": "Flour",
           "strIngredient5": "Baking Powder\n",
           "strIngredient6": "Salt ",
           "strIngredient7": "Unsalted Butter",
           "strIngredient8": "Sugar",
           "strIngredient9": "Peanut Butter",
           "strIngredient10": "",
           "strIngredient11": "",
           "strIngredient12": "",
           "strIngredient13": "",
           "strIngredient14": "",
           "strIngredient15": "",
           "strIngredient16": "",
           "strIngredient17": "",
           "strIngredient18": "",
           "strIngredient19": "",
           "strIngredient20": "",
           "strMeasure1": "200ml",
           "strMeasure2": "60ml",
           "strMeasure3": "2",
           "strMeasure4": "1600g",
           "strMeasure5": "3 tsp",
           "strMeasure6": "1/2 tsp",
           "strMeasure7": "25g",
           "strMeasure8": "45g",
           "strMeasure9": "3 tbs",
           "strMeasure10": " ",
           "strMeasure11": " ",
           "strMeasure12": " ",
           "strMeasure13": " ",
           "strMeasure14": " ",
           "strMeasure15": " ",
           "strMeasure16": " ",
           "strMeasure17": " ",
           "strMeasure18": " ",
           "strMeasure19": " ",
           "strMeasure20": " ",
           "strSource": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
           "strImageSource": null,
           "strCreativeCommonsConfirmed": null,
           "dateModified": null
        }
        """#.data(using: .utf8)!
        
        // When
        let mealDetailResult = try JSONDecoder().decode(MealDetail.Result.self, from: json)
        
        // Then
        XCTAssertEqual(
            mealDetailResult.id,
            "53049",
            "MealDetail.Result id should match JSON value"
        )
        XCTAssertEqual(
            mealDetailResult.title,
            "Apam Balik",
            "MealDetail.Result title should match JSON value with capitalization"
        )
        XCTAssertEqual(
            mealDetailResult.thumbnailImageUrl,
            URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")!,
            "MealDetail.Result thumbnailImageUrl should match JSON value"
        )
        XCTAssertEqual(
            mealDetailResult.category,
            "Dessert",
            "MealDetail.Result category should match JSON value"
        )
        XCTAssertEqual(
            mealDetailResult.region,
            "Malaysian",
            "MealDetail.Result region should match JSON value"
        )
        XCTAssertEqual(
            mealDetailResult.instructions.count,
            9,
            "MealDetail.Result instructions should match number of sentences in JSON value"
        )
        for instruction in mealDetailResult.instructions {
            XCTAssertFalse(
                instruction.isEmpty,
                "MealDetail.Result instruction should not be empty"
            )
            XCTAssertFalse(
                instruction.contains(where: \.isNewline),
                "MealDetail.Result instruction should not contain newline characters"
            )
            XCTAssertFalse(
                instruction.hasPrefix(" ") || instruction.hasSuffix(" "),
                "MealDetail.Result instruction should not begin or end with whitespace characters"
            )
            XCTAssertEqual(
                instruction.last,
                ".",
                "MealDetail.Result instruction should end with period"
            )
        }
        XCTAssertEqual(
            mealDetailResult.requirements.count,
            9,
            "MealDetail.Result requirements should match number of sentences in JSON value"
        )
        for requirement in mealDetailResult.requirements {
            XCTAssertFalse(
                requirement.ingredient.isEmpty,
                "MealDetail.Result required ingredient should not be empty"
            )
            XCTAssertFalse(
                requirement.ingredient.contains(where: \.isNewline),
                "MealDetail.Result required ingredient should not contain newline characters"
            )
            XCTAssertFalse(
                requirement.ingredient.hasPrefix(" ") || requirement.ingredient.hasSuffix(" "),
                "MealDetail.Result required ingredient should not begin or end with whitespace characters"
            )
        }
        for requirement in mealDetailResult.requirements {
            XCTAssertFalse(
                requirement.measurement.isEmpty,
                "MealDetail.Result required measurement should not be empty"
            )
            XCTAssertFalse(
                requirement.measurement.contains(where: \.isNewline),
                "MealDetail.Result required measurement should not contain newline characters"
            )
            XCTAssertFalse(
                requirement.measurement.hasPrefix(" ") || requirement.ingredient.hasSuffix(" "),
                "MealDetail.Result required measurement should not begin or end with whitespace characters"
            )
        }
        XCTAssertEqual(
            mealDetailResult.sourceUrl,
            URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")!,
            "MealDetail.Result sourceUrl should match JSON value"
        )
        XCTAssertEqual(
            mealDetailResult.youtubeUrl,
            URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")!,
            "MealDetail.Result youtubeUrl should match JSON value"
        )
    }
    
    func testDecodesMealDetail() throws {
        // Given
        let json = #"""
        {
            "meals": [
                {
                    "idMeal": "53049",
                    "strMeal": "Apam balik",
                    "strDrinkAlternate": null,
                    "strCategory": "Dessert",
                    "strArea": "Malaysian",
                    "strInstructions": "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm.",
                    "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
                    "strTags": null,
                    "strYoutube": "https://www.youtube.com/watch?v=6R8ffRRJcrg",
                    "strIngredient1": "Milk",
                    "strIngredient2": "Oil",
                    "strIngredient3": "Eggs",
                    "strIngredient4": "Flour",
                    "strIngredient5": "Baking Powder",
                    "strIngredient6": "Salt",
                    "strIngredient7": "Unsalted Butter",
                    "strIngredient8": "Sugar",
                    "strIngredient9": "Peanut Butter",
                    "strIngredient10": "",
                    "strIngredient11": "",
                    "strIngredient12": "",
                    "strIngredient13": "",
                    "strIngredient14": "",
                    "strIngredient15": "",
                    "strIngredient16": "",
                    "strIngredient17": "",
                    "strIngredient18": "",
                    "strIngredient19": "",
                    "strIngredient20": "",
                    "strMeasure1": "200ml",
                    "strMeasure2": "60ml",
                    "strMeasure3": "2",
                    "strMeasure4": "1600g",
                    "strMeasure5": "3 tsp",
                    "strMeasure6": "1/2 tsp",
                    "strMeasure7": "25g",
                    "strMeasure8": "45g",
                    "strMeasure9": "3 tbs",
                    "strMeasure10": " ",
                    "strMeasure11": " ",
                    "strMeasure12": " ",
                    "strMeasure13": " ",
                    "strMeasure14": " ",
                    "strMeasure15": " ",
                    "strMeasure16": " ",
                    "strMeasure17": " ",
                    "strMeasure18": " ",
                    "strMeasure19": " ",
                    "strMeasure20": " ",
                    "strSource": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "strImageSource": null,
                    "strCreativeCommonsConfirmed": null,
                    "dateModified": null
                }
            ]
        }
        """#.data(using: .utf8)!
        
        // When
        let mealDetail = try JSONDecoder().decode(MealDetail.self, from: json)
        
        // Then
        XCTAssertNotNil(
            mealDetail.result,
            "MealDetail should contain Result"
        )
    }
}
