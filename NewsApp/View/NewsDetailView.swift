//
//  NewsDetailView.swift
//  NewsApp

import SwiftUI

struct NewsDetailView: View {
    @StateObject var viewModel: NewsDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Optional: Display Image if URL is available
                if let imageUrl = viewModel.article.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView() // Show progress view while loading image
                    }
                    .frame(maxWidth: .infinity)
                }

                // Article Title
                Text(viewModel.article.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 8)

                // Article Author and Source (if available)
                if let author = viewModel.article.author {
                    Text("By \(author) - \(viewModel.article.source.name)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Published Date
                Text(viewModel.formatDate(viewModel.article.publishedAt))
                    .font(.footnote)
                    .foregroundColor(.gray)

                // Article Description
                if let description = viewModel.article.description {
                    Text(description)
                        .font(.body)
                        .padding(.vertical, 8)
                }

                // Article Content
                if let content = viewModel.article.content {
                    Text(content)
                        .font(.body)
                        .padding(.vertical, 8)
                } else {
                    Text("Full article content is not available.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.vertical, 8)
                }

                // Optional: Link to the full article
                if let articleUrl = viewModel.articleURL() {
                    Link("Read Full Article", destination: articleUrl)
                        .foregroundColor(.blue)
                        .font(.headline)
                        .padding(.top, 16)
                }
            }
            .padding()
        }
        .navigationTitle("Article Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    NewsDetailView()
//}
