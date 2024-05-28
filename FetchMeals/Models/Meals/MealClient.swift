//
//  MealClient.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/22/24.
//

import ComposableArchitecture
import Foundation

// MARK: - API client interface

// Typically this interface would live in its own module, separate from the live implementation.
// This allows the search feature to compile faster since it only depends on the interface.

@DependencyClient
struct MealClient {
    var mealCategories: @Sendable () async throws -> MealCategory
    var mealSummaries: @Sendable (_ category: String) async throws -> MealSummary
    var mealDetail: @Sendable (_ id: String) async throws -> MealDetail
}

extension MealClient: TestDependencyKey {
    static let mock = Self(
        mealCategories: { .mock },
        mealSummaries: { _ in .mock },
        mealDetail: { _ in .mock }
    )
    
    static let testValue = Self()
}

extension DependencyValues {
    var mealClient: MealClient {
        get { self[MealClient.self] }
        set { self[MealClient.self] = newValue }
    }
}

// MARK: - Live API implementation

extension MealClient: DependencyKey {
    static let liveValue = MealClient(
        mealCategories: {
            var components = URLComponents(string: "https://themealdb.com/api/json/v1/1/categories.php")!
            
            let (data, _) = try await URLSession.shared.data(from: components.url!)
            return try jsonDecoder.decode(MealCategory.self, from: data)
        },
        mealSummaries: { category in
            var components = URLComponents(string: "https://themealdb.com/api/json/v1/1/filter.php")!
            components.queryItems = [
                URLQueryItem(name: "c", value: category)
            ]
            
            let (data, _) = try await URLSession.shared.data(from: components.url!)
            return try jsonDecoder.decode(MealSummary.self, from: data)
        },
        mealDetail: { id in
            var components = URLComponents(string: "https://themealdb.com/api/json/v1/1/lookup.php")!
            components.queryItems = [
                URLQueryItem(name: "i", value: id)
            ]
            
            let (data, _) = try await URLSession.shared.data(from: components.url!)
            return try jsonDecoder.decode(MealDetail.self, from: data)
        }
    )
}

// MARK: - Private helpers

private let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    decoder.dateDecodingStrategy = .formatted(formatter)
    return decoder
}()
