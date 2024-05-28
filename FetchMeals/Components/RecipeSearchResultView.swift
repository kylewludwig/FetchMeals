//
//  RecipeSearchResultView.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/26/24.
//

import SwiftUI

public struct RecipeSearchResultView: View {
    let result: MealSummary.Result
    
    public init(_ result: MealSummary.Result) {
        self.result = result
    }
    
    public var body: some View {
        HStack(alignment: .center) {
            AsyncImage(
                url: result.thumbnailImageUrl,
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                },
                placeholder: {
                    Rectangle()
                        .foregroundColor(.gray)
                }
            )
            .frame(width: 64, height: 64)
            .aspectRatio(1, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay {
                RoundedRectangle(cornerRadius: 4).stroke(.white, lineWidth: 4)
            }
            .shadow(color: .black.opacity(0.12), radius: 4)
            Text(result.title)
                .font(.body)
            Spacer()
            Image(systemName: "chevron.right")
                .imageScale(.large)
                .symbolRenderingMode(.monochrome)
                .foregroundColor(.blue)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    RecipeSearchResultView(MealSummary.mock.results.first!)
}
