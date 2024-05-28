//
//  MealSearchFeatureTests.swift
//  FetchMealsTests
//
//  Created by Kyle Ludwig on 5/27/24.
//

@testable import FetchMeals
import ComposableArchitecture
import XCTest

final class MealSearchFeatureTests: XCTestCase {
    @MainActor
    func testMealCategoryLoadsWithSuccess() async {
        let store = TestStore(initialState: MealSearchFeature.State()) {
            MealSearchFeature()
        } withDependencies: {
            $0.mealClient.mealCategories = { @Sendable in
                return MealCategory.mock
            }
        }
        
        await store.send(\.loadMealCategory)
        
        await store.receive(\.mealCategoryResponse.success, MealCategory.mock) {
            $0.mealCategoryResults = MealCategory.mock.results
        }
    }
    
    @MainActor
    func testMealCategoryLoadsWithError() async {
        let store = TestStore(initialState: MealSearchFeature.State()) {
            MealSearchFeature()
        } withDependencies: {
            $0.mealClient.mealCategories = { @Sendable in
                struct MealCategoryFailure: Error {}
                throw MealCategoryFailure()
            }
        }
        
        await store.send(\.loadMealCategory)
        
        await store.receive(\.mealCategoryResponse.failure)
    }
    
    @MainActor
    func testMealSummaryLoadsWithSuccess() async {
        let store = TestStore(initialState: MealSearchFeature.State()) {
            MealSearchFeature()
        } withDependencies: {
            $0.mealClient.mealSummaries = { @Sendable _ in
                return MealSummary.mock
            }
        }
        
        await store.send(\.loadMealSummary)
        
        await store.receive(\.mealSummaryResponse.success, MealSummary.mock) {
            $0.mealSummaryResults = MealSummary.mock.results
        }
    }
    
    @MainActor
    func testMealSummaryLoadsWithError() async {
        let store = TestStore(initialState: MealSearchFeature.State()) {
            MealSearchFeature()
        } withDependencies: {
            $0.mealClient.mealSummaries = { @Sendable _ in
                struct MealSummaryFailure: Error {}
                throw MealSummaryFailure()
            }
        }
        
        await store.send(\.loadMealSummary)
        
        await store.receive(\.mealSummaryResponse.failure)
    }
}
