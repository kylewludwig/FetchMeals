//
//  MealSearchCore.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/23/24.
//

import ComposableArchitecture
import IdentifiedCollections

@Reducer
struct MealSearchFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var showMealDetails: MealDetailsFeature.State?
        var mealCategoryResults: IdentifiedArrayOf<MealCategory.Result> = []
        var selectedCategory: String = "Dessert"
        var mealSummaryResults: IdentifiedArrayOf<MealSummary.Result> = []
    }
    
    enum Action {
        case loadMealCategory
        case mealCategoryResponse(_ response: Result<MealCategory, Error>)
        case mealCategoryTapped(_ result: MealCategory.Result)
        case loadMealSummary
        case mealSummaryResponse(_ response: Result<MealSummary, Error>)
        case mealSummaryResultTapped(_ result: MealSummary.Result)
        case showMealDetails(PresentationAction<MealDetailsFeature.Action>)
    }
    
    @Dependency(\.mealClient) var mealClient
    private enum CancelID { case mealCategory, mealSummary }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadMealCategory:
                return .run { send in
                    await send(.mealCategoryResponse(Result {
                        try await mealClient.mealCategories()
                    }))
                }
                .cancellable(id: CancelID.mealCategory)
                
            case let .mealCategoryResponse(.success(mealCategory)):
                state.mealCategoryResults = mealCategory.results
                return .none
                
            case .mealCategoryResponse(.failure):
                state.mealCategoryResults = []
                return .none
                
            case let .mealCategoryTapped(category):
                state.selectedCategory = category.title
                return .run { [category = state.selectedCategory] send in
                    await send(.mealSummaryResponse(Result {
                        try await mealClient.mealSummaries(category: category)
                    }))
                }
                .cancellable(id: CancelID.mealSummary)
                
            case .loadMealSummary:
                return .run { [category = state.selectedCategory] send in
                    await send(.mealSummaryResponse(Result {
                        try await mealClient.mealSummaries(category: category)
                    }))
                }
                .cancellable(id: CancelID.mealSummary)
                
            case .mealSummaryResponse(.failure):
                state.mealSummaryResults = []
                return .none
                
            case let .mealSummaryResponse(.success(response)):
                var results = response.results
                results.sort(by: { $0.title < $1.title })
                state.mealSummaryResults = results
                return .none
                
            case let .mealSummaryResultTapped(mealSummaryResult):
                state.showMealDetails = MealDetailsFeature.State(
                    mealId: mealSummaryResult.id,
                    mealDetailResult: nil
                )
                return .none
                
            case .showMealDetails(.presented(.closeButtonTapped)):
                state.showMealDetails = nil
                return .none
                
            case .showMealDetails:
                return .none
                
            }
        }
        .ifLet(\.$showMealDetails, action: \.showMealDetails) {
            MealDetailsFeature()
        }
    }
}
