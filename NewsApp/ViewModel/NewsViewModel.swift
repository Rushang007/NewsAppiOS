//
//  NewsViewModel.swift
//  NewsApp

import Foundation

class NewsViewModel: ObservableObject {
    
    var networkManager: NetworkManager
    @Published var articles: [Article] = []
    @Published var selectedCategory: NewsCategory = .general {
        didSet {
            fetchArticles(url: createURL()) // Fetch articles whenever the selected category changes
        }
    }
    @Published var isLoading = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var navigateToDetailView = false
    
    private let bookmarksKey = "bookmarkedArticles" // UserDefaults key for bookmarks
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
        loadBookmarks() // Load bookmarks from UserDefaults on initialization
    }
    
    // Function to bookmark an article by URL
    func bookmarkArticle(_ article: Article) {
        if let index = articles.firstIndex(where: { $0 == article }) {
            var bookmarkedArticles = fetchBookmarkedURLs() // Get current bookmarks
            if !bookmarkedArticles.contains(article.url) {
                bookmarkedArticles.append(article.url) // Add URL to bookmarks
                saveBookmarks(bookmarkedArticles) // Save updated bookmarks to UserDefaults
            }
            articles[index].isBookmarked = true
        }
        
    }
    
    // Function to remove a bookmark by URL
    func removeBookmark(_ article: Article) {
        if let index = articles.firstIndex(where: { $0 == article }) {
            var bookmarkedArticles = fetchBookmarkedURLs() // Get current bookmarks
            if let index = bookmarkedArticles.firstIndex(of: article.url) {
                bookmarkedArticles.remove(at: index) // Remove the URL
                saveBookmarks(bookmarkedArticles) // Save updated bookmarks to UserDefaults
            }
            articles[index].isBookmarked = false
        }
    }
    
    // Function to check if an article is bookmarked by URL
    func isBookmarked(_ article: Article) -> Bool {
        let bookmarkedArticles = fetchBookmarkedURLs() // Get current bookmarks
        return bookmarkedArticles.contains(article.url) // Check if URL is in bookmarks
    }
    
    // Load bookmarks from UserDefaults
        func loadBookmarks() {
           let bookmarkedArticles = fetchBookmarkedURLs() // Fetch bookmarks
           for url in bookmarkedArticles {
               // Set the isBookmarked flag for each article that matches the URL
               if let index = articles.firstIndex(where: { $0.url == url }) {
                   articles[index].isBookmarked = true
               }
           }
       }

    // Fetch bookmarked URLs from UserDefaults
    private func fetchBookmarkedURLs() -> [String] {
        return UserDefaults.standard.stringArray(forKey: bookmarksKey) ?? [] // Retrieve bookmarks
    }
    
    // Save bookmarked URLs to UserDefaults
    private func saveBookmarks(_ bookmarks: [String]) {
        UserDefaults.standard.setValue(bookmarks, forKey: bookmarksKey) // Save bookmarks
    }
    
    func updateSelectedCategory(_ category: NewsCategory) {
            selectedCategory = category
        }
    
     func createURL() -> URL? {
        let urlString = "\(Constants.NewsAPI.baseURL)?country=\(Constants.country)&category=\(selectedCategory.rawValue)&apiKey=\(Constants.NewsAPI.apiKey)"
        return URL(string: urlString)
    }
    
    // Fetch news articles from server
    func fetchArticles(url:URL?,completion: ((String?) -> Void)? = nil){
        guard let url = url else {
            alertMessage = APIError.invalidURL.localizedDescription
            showAlert = true
            completion?(alertMessage)
            return
        }
        
        self.isLoading = true
        self.networkManager.performRequest(url: url,method: .get) { (result: Result<NewsResponse, APIError>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.articles = response.articles ?? []
                    completion?(response.message ?? nil)
                    self.loadBookmarks()
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                    completion?(error.localizedDescription)
                    
                }
            }
        }
    }
}
