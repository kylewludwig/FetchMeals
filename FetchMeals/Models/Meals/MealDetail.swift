//
//  MealDetail.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/22/24.
//

import Foundation

// MARK: - API model

struct MealDetail: Equatable, Sendable {
    let result: Result
    
    struct Result: Equatable, Identifiable, Sendable {
        let id: String
        let title: String
        let thumbnailImageUrl: URL?
        let category: String
        let region: String
        let instructions: [String]
        let requirements: [Requirement]
        let sourceUrl: URL?
        let youtubeUrl: URL?
        
        static func == (lhs: Result, rhs: Result) -> Bool {
            return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.thumbnailImageUrl == rhs.thumbnailImageUrl
            && lhs.category == rhs.category
            && lhs.region == rhs.region
            && lhs.instructions == rhs.instructions
            && lhs.requirements == rhs.requirements
            && lhs.sourceUrl == rhs.sourceUrl
            && lhs.youtubeUrl == rhs.youtubeUrl
        }
    }
    
    struct Requirement: Equatable, Identifiable {
        let id = UUID()
        let measurement: String
        let ingredient: String
        
        static func == (lhs: Requirement, rhs: Requirement) -> Bool {
            return lhs.measurement == rhs.measurement
            && lhs.ingredient == rhs.ingredient
        }
    }
}

extension MealDetail: Decodable {
    enum CodingKeys: String, CodingKey {
        case result = "meals"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.decode([Result].self, forKey: .result)
        guard let result = results.first else {
            throw DecodingError.mealDetailsNotFound // Ensures API returns a single result
        }
        self.result = result
    }
}

extension MealDetail.Result: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case title = "strMeal"
        case thumbnailImageUrl = "strMealThumb"
        case category = "strCategory"
        case region = "strArea"
        case instructions = "strInstructions"
        case ingredients = "strIngredient"
        case measurements = "strMeasure"
        case sourceUrl = "strSource"
        case youtubeUrl = "strYoutube"
    }
    
    private enum IngredientCodingKeys: String, CodingKey, CaseIterable {
        case ingredient1 = "strIngredient1",
             ingredient2 = "strIngredient2",
             ingredient3 = "strIngredient3",
             ingredient4 = "strIngredient4",
             ingredient5 = "strIngredient5",
             ingredient6 = "strIngredient6",
             ingredient7 = "strIngredient7",
             ingredient8 = "strIngredient8",
             ingredient9 = "strIngredient9",
             ingredient10 = "strIngredient10",
             ingredient11 = "strIngredient11",
             ingredient12 = "strIngredient12",
             ingredient13 = "strIngredient13",
             ingredient14 = "strIngredient14",
             ingredient15 = "strIngredient15",
             ingredient16 = "strIngredient16",
             ingredient17 = "strIngredient17",
             ingredient18 = "strIngredient18",
             ingredient19 = "strIngredient19",
             ingredient20 = "strIngredient20"
    }
    
    private enum MeasurementCodingKeys: String, CodingKey, CaseIterable {
        case measurement1 = "strMeasure1",
             measurement2 = "strMeasure2",
             measurement3 = "strMeasure3",
             measurement4 = "strMeasure4",
             measurement5 = "strMeasure5",
             measurement6 = "strMeasure6",
             measurement7 = "strMeasure7",
             measurement8 = "strMeasure8",
             measurement9 = "strMeasure9",
             measurement10 = "strMeasure10",
             measurement11 = "strMeasure11",
             measurement12 = "strMeasure12",
             measurement13 = "strMeasure13",
             measurement14 = "strMeasure14",
             measurement15 = "strMeasure15",
             measurement16 = "strMeasure16",
             measurement17 = "strMeasure17",
             measurement18 = "strMeasure18",
             measurement19 = "strMeasure19",
             measurement20 = "strMeasure20"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        // Ensure strings for recipe titles are always capitalized since the response gives both capitalized and lowercased strings.
        let mixedCaseTitle = try container.decode(String.self, forKey: .title)
        title = mixedCaseTitle.capitalized
        
        thumbnailImageUrl = try? container.decodeIfPresent(URL.self, forKey: .thumbnailImageUrl)
        category = try container.decode(String.self, forKey: .category)
        region = try container.decode(String.self, forKey: .region)
        
        // Parse instructions into a line-by-line list each ending with a period
        let singleLineInstructions = try container.decode(String.self, forKey: .instructions)
        instructions = RecipeParser.parseInstructions(singleLineInstructions)
        
        // Parse non-nil & non-empty list of ingredients
        let ingredientsContainer = try decoder.container(keyedBy: IngredientCodingKeys.self)
        let decodedIngredients = IngredientCodingKeys.allCases
            .compactMap { try? ingredientsContainer.decode(String.self, forKey: $0) }
        let ingredients = RecipeParser.parseIngredients(decodedIngredients)
        
        // Parse non-nil & non-empty list of measurements
        let measurementsContainer = try decoder.container(keyedBy: MeasurementCodingKeys.self)
        let decodedMeasurements = MeasurementCodingKeys.allCases
            .compactMap { try? measurementsContainer.decode(String.self, forKey: $0) }
        let measurements = RecipeParser.parseMeasurements(decodedMeasurements)
        
        // Combine list of ingredients and measurements into a list of requirements
        if (ingredients.count != measurements.count) {
            throw DecodingError.invalidMealRequirements
        } else {
            requirements = zip(ingredients, measurements)
                .map { MealDetail.Requirement(measurement: $0.1, ingredient: $0.0) }
        }
        
        sourceUrl = try? container.decodeIfPresent(URL.self, forKey: .sourceUrl)
        youtubeUrl = try? container.decodeIfPresent(URL.self, forKey: .youtubeUrl)
    }
}

// MARK: - Mock data

extension MealDetail {
    static let mock = Self(
        result: .init(
            id: "52893",
            title: "Apple & Blackberry Crumble",
            thumbnailImageUrl: URL(string: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"),
            category: "Dessert",
            region: "British",
            instructions: [
                "Heat oven to 190C/170C fan/gas 5.",
                "Tip the flour and sugar into a large bowl.",
                "Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture.",
                "Do not overwork it or the crumble will become heavy.",
                "Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.",
                "Meanwhile, for the compote, peel, core and cut the apples into 2cm dice.",
                "Put the butter and sugar in a medium saucepan and melt together over a medium heat.",
                "Cook for 3 mins until the mixture turns to a light caramel.",
                "Stir in the apples and cook for 3 mins.",
                "Add the blackberries and cinnamon, and cook for 3 mins more.",
                "Cover, remove from the heat, then leave for 2-3 mins to continue cooking in the warmth of the pan.",
                "To serve, spoon the warm fruit into an ovenproof gratin dish, top with the crumble mix, then reheat in the oven for 5-10 mins.",
                "Serve with vanilla ice cream."
            ],
            requirements: [
                .init(
                    measurement: "120g",
                    ingredient: "Plain Flour"
                ),
                .init(
                    measurement: "60g",
                    ingredient: "Caster Sugar"
                ),
                .init(
                    measurement: "60g",
                    ingredient: "Butter"
                ),
                .init(
                    measurement: "300g",
                    ingredient: "Braeburn Apples"
                ),
                .init(
                    measurement: "30g",
                    ingredient: "Butter"
                ),
                .init(
                    measurement: "30g",
                    ingredient: "Demerara Sugar"
                ),
                .init(
                    measurement: "120g",
                    ingredient: "Blackberrys"
                ),
                .init(
                    measurement: "¼ teaspoon",
                    ingredient: "Cinnamon"
                ),
                .init(
                    measurement: "to serve",
                    ingredient: "Ice Cream"
                )
            ],
            sourceUrl: URL(string: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble"),
            youtubeUrl: URL(string: "https://www.youtube.com/watch?v=4vhcOwVBDO4")
        )
    )
}
