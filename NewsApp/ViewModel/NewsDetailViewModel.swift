//
//  NewsDetailViewModel.swift
//  NewsApp

import Foundation

class NewsDetailViewModel: ObservableObject {
    @Published var article: Article
    
    init(article: Article) {
        self.article = article
    }
    
    // Helper function to format the published date
    func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .medium
            return outputFormatter.string(from: date)
        }
        return dateString
    }
    
    // Function to get article URL
    func articleURL() -> URL? {
        return URL(string: article.url)
    }
}
