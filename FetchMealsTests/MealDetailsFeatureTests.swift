//
//  MealDetailsFeatureTests.swift
//  FetchMealsTests
//
//  Created by Kyle Ludwig on 5/27/24.
//

@testable import FetchMeals
import ComposableArchitecture
import XCTest

final class MealDetailsFeatureTests: XCTestCase {
    @MainActor
    func testMealDetailsLoadsWithSuccess() async {
        let store = TestStore(initialState: MealDetailsFeature.State(mealId: "52893")) {
            MealDetailsFeature()
        } withDependencies: {
            $0.mealClient.mealDetail = { @Sendable _ in
                return MealDetail.mock
            }
        }
        
        await store.send(\.loadMealDetail)
        
        await store.receive(\.mealDetailResponse.success, MealDetail.mock) {
            $0.isLoading = false
            $0.mealDetailResult = MealDetail.mock.result
        }
    }
    
    @MainActor
    func testMealDetailsLoadsWithFailure() async {
        let store = TestStore(initialState: MealDetailsFeature.State(mealId: "52893")) {
            MealDetailsFeature()
        } withDependencies: {
            $0.mealClient.mealDetail = { @Sendable _ in
                struct MealDetailsFailure: Error {}
                throw MealDetailsFailure()
            }
        }
        
        await store.send(\.loadMealDetail)
        
        await store.receive(\.mealDetailResponse.failure) {
            $0.isLoading = false
            $0.mealDetailResult = nil
        }
    }
    
    @MainActor
    func testMealDetailsDismisses() async {
        let store = TestStore(initialState: MealDetailsFeature.State(mealId: "52893")) {
            MealDetailsFeature()
        } withDependencies: {
            $0.mealClient.mealDetail = { @Sendable _ in
                struct MealDetailsFailure: Error {}
                throw MealDetailsFailure()
            }
        }
        
        await store.send(\.loadMealDetail)
        
        await store.receive(\.mealDetailResponse.failure) {
            $0.isLoading = false
            $0.mealDetailResult = nil
        }
    }
}




























































































