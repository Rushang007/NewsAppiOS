//
//  Article.swift
//  NewsApp

import Foundation

// Define a struct for the overall news response
struct NewsResponse: Codable {
    let status: String?
    let totalResults: Int?
    let code: String?
    let message:String?
    var articles: [Article]?
    
    enum CodingKeys: CodingKey {
        case status
        case totalResults
        case code
        case message
        case articles
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults)
        self.code = try container.decodeIfPresent(String.self, forKey: .code)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.articles = try? container.decode([Article].self, forKey: .articles)
    }
}

// Define a struct for a news article
struct Article: Codable, Identifiable,Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
            return lhs.url == rhs.url // Use URL as a unique identifier
        }
    
    let id = UUID()
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    var isBookmarked: Bool = false

    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt, content
    }
}

// Define a struct for the news source
struct Source: Codable {
    let id: String?
    let name: String
}


