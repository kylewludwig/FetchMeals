//
//  SearchResultSectionHeaderView.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/26/24.
//

import SwiftUI

struct SearchResultSectionHeaderView: View {
    let title: String
    
    public init(
        _ title: String
    ) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 0)
            .padding(.horizontal, 16)
            .zIndex(1)
    }
}

#Preview {
    SearchResultSectionHeaderView("Section Heading")
}
