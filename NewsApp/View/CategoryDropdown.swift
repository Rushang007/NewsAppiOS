//
//  CategoryDropdown.swift
//  NewsApp
//
//  Created by MTPC-405 on 21/10/24.
//

import SwiftUI

struct CategoryDropdown: View {
    @Binding var selectedCategory: NewsCategory // Binding to update the selected category
    private let categories: [NewsCategory] = [.business, .entertainment, .general, .health, .science, .sports, .technology]

    var body: some View {
        Menu {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    selectedCategory = category // Update the selected category
                }) {
                    Text(category.rawValue.capitalized) // Show category name
                }
            }
        } label: {
            HStack {
                Text("Category: \(selectedCategory.rawValue.capitalized)") // Display selected category
                    .font(.headline)

                Spacer() // Space to push the arrow
                Image(systemName: "chevron.down") // Dropdown arrow
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.2)) // Background color
            .cornerRadius(8) // Rounded corners
        }
        .padding() // Padding around the dropdown
    }
}
