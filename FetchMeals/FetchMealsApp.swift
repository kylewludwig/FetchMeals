//
//  FetchMealsApp.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/22/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct FetchMealsApp: App {
    var body: some Scene {
        WindowGroup {
            MealSearchView(
                store: Store(initialState: MealSearchFeature.State()) {
                    MealSearchFeature()
                        ._printChanges()
                }
            )
        }
    }
}
