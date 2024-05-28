//
//  MealSummary.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/22/24.
//

import Foundation
import IdentifiedCollections

// MARK: - API model

public struct MealSummary: Equatable, Sendable {
    let results: IdentifiedArrayOf<Result>
    
    public struct Result: Equatable, Identifiable, Sendable {
        public let id: String
        let title: String
        let thumbnailImageUrl: URL?
        
        public static func == (lhs: Result, rhs: Result) -> Bool {
            return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.thumbnailImageUrl == rhs.thumbnailImageUrl
        }
    }
}

extension MealSummary: Decodable {
    enum CodingKeys: String, CodingKey {
        case results = "meals"
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode(IdentifiedArrayOf<Result>.self, forKey: .results)
    }
}

extension MealSummary.Result: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case title = "strMeal"
        case thumbnailImageUrl = "strMealThumb"
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        // Ensure strings for recipe titles are always capitalized since the response gives both capitalized and lowercased strings.
        let mixedCaseTitle = try container.decode(String.self, forKey: .title)
        title = mixedCaseTitle.capitalized
        thumbnailImageUrl = try? container.decodeIfPresent(URL.self, forKey: .thumbnailImageUrl)
    }
}


// MARK: - Mock data

extension MealSummary {
    static let mock = Self(
        results: [
            .init(
                id: "53049",
                title: "Apam Balik",
                thumbnailImageUrl: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
            ),
            .init(
                id: "52893",
                title: "Apple & Blackberry Crumble",
                thumbnailImageUrl: URL(string: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg")
            ),
            .init(
                id: "52768",
                title: "Apple Frangipan Tart",
                thumbnailImageUrl: URL(string: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg")
            ),
        ]
    )
}
