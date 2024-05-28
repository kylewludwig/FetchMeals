//
//  MealDetailsCore.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/23/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MealDetailsFeature {
    @ObservableState
    struct State: Equatable {
        var isLoading = true
        var mealId: MealSummary.Result.ID
        var mealDetailResult: MealDetail.Result?
    }
    
    enum Action: Sendable {
        case loadMealDetail
        case mealDetailResponse(Result<MealDetail, Error>)
        case closeButtonTapped
    }
    
    @Dependency(\.mealClient) var mealClient
    private enum CancelID { case mealDetail }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadMealDetail:
                state.isLoading = true
                return .run { [id = state.mealId] send in
                    await send(.mealDetailResponse(Result {
                        try await mealClient.mealDetail(id: id)
                    }))
                }
                .cancellable(id: CancelID.mealDetail)
                
            case .mealDetailResponse(.failure):
                state.isLoading = false
                state.mealDetailResult = nil
                return .none
                
            case let .mealDetailResponse(.success(response)):
                state.isLoading = false
                state.mealDetailResult = response.result
                return .none
                
            case .closeButtonTapped:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
