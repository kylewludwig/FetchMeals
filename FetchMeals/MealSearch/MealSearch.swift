//
//  MealSearch.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/22/24.
//

import ComposableArchitecture
import SwiftUI

struct MealSearchView: View {
    @Bindable var store: StoreOf<MealSearchFeature>
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchResultSectionHeaderView("Categories")
                ScrollView(.horizontal) {
                    LazyHStack(alignment: .center, spacing: 16) {
                        ForEach(store.mealCategoryResults) { result in
                            CategorySearchResultView(result: result)
                                .onTapGesture {
                                    store.send(.mealCategoryTapped(result))
                                }
                        }
                    }
                    .frame(maxHeight: 152)
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.hidden)
                .task {
                    await store.send(.loadMealCategory).finish()
                }
            }
            VStack {
                SearchResultSectionHeaderView("Recipes")
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(store.mealSummaryResults) { result in
                            RecipeSearchResultView(result)
                                .onTapGesture {
                                    store.send(.mealSummaryResultTapped(result))
                                }
                        }
                    }
                }
                .task {
                    await store.send(.loadMealSummary).finish()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Meals")
        .sheet(
            item: $store.scope(state: \.showMealDetails, action: \.showMealDetails)
        ) { mealDetailsStore in
            NavigationStack {
                MealDetailsView(store: mealDetailsStore)
            }
        }
    }
}

#Preview {
    MealSearchView(
        store: Store(initialState: MealSearchFeature.State()) {
            MealSearchFeature()
                .dependency(\.mealClient, .mock)
        }
    )
}
