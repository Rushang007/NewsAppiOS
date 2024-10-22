//
//  NewsRowView.swift
//  NewsApp


import SwiftUI

// Custom row view for displaying a single article's title and description
struct NewsRowView: View {
    let article: Article
    @EnvironmentObject var viewModel: NewsViewModel // Access the ViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(article.description ?? "No description available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .padding(.top, 2)
            }
            .padding(.vertical, 8)
            
            Spacer() // Push the bookmark button to the right
            
            Button(action: {
                if viewModel.isBookmarked(article) {
                    viewModel.removeBookmark(article) // Remove bookmark if already bookmarked
                } else {
                    viewModel.bookmarkArticle(article) // Add to bookmarks
                }
            }) {
                Image(systemName: viewModel.isBookmarked(article) ? "star.fill" : "star") // Use the isBookmarked function
                    .foregroundColor(viewModel.isBookmarked(article) ? .yellow : .gray) // Change color based on bookmark status
            }
            .buttonStyle(PlainButtonStyle()) // Remove default button style
        }
        .background(Color.white) // Add background to distinguish rows
    }
}

