//
//  CategorySearchResultView.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/26/24.
//

import SwiftUI

struct CategorySearchResultView: View {
    let result: MealCategory.Result
    
    var body: some View {
        VStack(alignment: .center) {
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
            .frame(width: 96, height: 96)
            .aspectRatio(1, contentMode: .fill)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(color: .black.opacity(0.24), radius: 6)
            Text(result.title)
                .font(.body)
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    CategorySearchResultView(result: MealCategory.mock.results.first!)
}
