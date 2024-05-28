//
//  MealDetails.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/22/24.
//

import ComposableArchitecture
import SwiftUI

struct MealDetailsView: View {
    @Bindable var store: StoreOf<MealDetailsFeature>
    
    var body: some View {
        ZStack {
            if store.isLoading {
                recipeDetailsView(MealDetail.mock.result)
            } else if let result = store.mealDetailResult {
                recipeDetailsView(result)
            } else {
                errorView()
            }
        }
        .redacted(reason: store.isLoading ? .placeholder : [])
        .task {
            await store.send(.loadMealDetail).finish()
        }
    }
    
    @ViewBuilder
    private func recipeDetailsView(_ result: MealDetail.Result) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(result.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true) // Fix to enable .headline and .title text wrapping
                    Text(result.region + " " + result.category)
                }
                AsyncImage(
                    url: result.thumbnailImageUrl
                ) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.gray)
                }
                .imageScale(.large)
                .foregroundStyle(.tint)
                .aspectRatio(16/9, contentMode: .fill)
                .frame(height: 200)
                .cornerRadius(4)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Required Ingredients")
                        .font(.title2)
                        .fontWeight(.bold)
                    ForEach(result.requirements) { requirement in
                        Text(requirement.measurement + " " + requirement.ingredient)
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions")
                        .font(.title2)
                        .fontWeight(.bold)
                    ForEach(Array(result.instructions.enumerated()), id:\.element) { index, instruction in
                        Text("\(index + 1). \(instruction)")
                    }
                }
            }
            .padding([.leading, .trailing], 16)
            .padding([.top, .bottom], 32)
        }
    }
    
    @ViewBuilder
    private func errorView() -> some View {
        VStack(alignment: .center, spacing: 24) {
            Image("cupcake")
                .resizable()
                .scaledToFill()
                .cornerRadius(8)
                .frame(width: 144, height: 144)
            VStack(alignment: .center, spacing: 8) {
                Text("Uh-oh!")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("This recipe was so good the internet must've eaten it")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text("Try refreshing this page or finding another delicious recipe")
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            Button("Let's Go") {
                store.send(.closeButtonTapped)
            }
        }
        .padding()
    }
}

#Preview {
    MealDetailsView(
        store: Store(
            initialState: .init(
                isLoading: false,
                mealId: "52893",
                mealDetailResult: nil
            )
        ) {
            MealDetailsFeature()
                .dependency(\.mealClient, .mock)
        }
    )
}
