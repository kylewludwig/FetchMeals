//
//  MealCategory.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/26/24.
//

import Foundation
import IdentifiedCollections

// MARK: - API model

struct MealCategory: Equatable, Sendable {
    let results: IdentifiedArrayOf<Result>
    
    struct Result: Equatable, Identifiable, Sendable {
        let id: String
        let title: String
        let description: String
        let thumbnailImageUrl: URL?
        
        static func == (lhs: Result, rhs: Result) -> Bool {
            return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.thumbnailImageUrl == rhs.thumbnailImageUrl
        }
    }
}

extension MealCategory: Decodable {
    enum CodingKeys: String, CodingKey {
        case results = "categories"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode(IdentifiedArrayOf<Result>.self, forKey: .results)
    }
}

extension MealCategory.Result: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case title = "strCategory"
        case description = "strCategoryDescription"
        case thumbnailImageUrl = "strCategoryThumb"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        // Ensure strings for category titles are always capitalized since the response gives both capitalized and lowercased strings.
        let mixedCaseTitle = try container.decode(String.self, forKey: .title)
        title = mixedCaseTitle.capitalized
        thumbnailImageUrl = try? container.decodeIfPresent(URL.self, forKey: .thumbnailImageUrl)
    }
}

// MARK: - Mock data

extension MealCategory {
    static let mock = Self(
        results: [
            .init(
                id: "1",
                title: "Beef",
                description: "Beef is the culinary name for meat from cattle, particularly skeletal muscle. Humans have been eating beef since prehistoric times.[1] Beef is a source of high-quality protein and essential nutrients.[2]",
                thumbnailImageUrl: URL(string: "https://www.themealdb.com/images/category/beef.png")
            ),
            .init(
                id: "2",
                title: "Chicken",
                description: "Chicken is a type of domesticated fowl, a subspecies of the red junglefowl. It is one of the most common and widespread domestic animals, with a total population of more than 19 billion as of 2011.[1] Humans commonly keep chickens as a source of food (consuming both their meat and eggs) and, more rarely, as pets.",
                thumbnailImageUrl: URL(string: "https://www.themealdb.com/images/category/chicken.png")
            ),
            .init(
                id: "3",
                title: "Dessert",
                description: "Dessert is a course that concludes a meal. The course usually consists of sweet foods, such as confections dishes or fruit, and possibly a beverage such as dessert wine or liqueur, however in the United States it may include coffee, cheeses, nuts, or other savory items regarded as a separate course elsewhere. In some parts of the world, such as much of central and western Africa, and most parts of China, there is no tradition of a dessert course to conclude a meal.\r\n\r\nThe term dessert can apply to many confections, such as biscuits, cakes, cookies, custards, gelatins, ice creams, pastries, pies, puddings, and sweet soups, and tarts. Fruit is also commonly found in dessert courses because of its naturally occurring sweetness. Some cultures sweeten foods that are more commonly savory to create desserts.",
                thumbnailImageUrl: URL(string: "https://www.themealdb.com/images/category/dessert.png")
            )
        ]
    )
}
