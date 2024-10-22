//
//  NewsDetailTests.swift
//  NewsAppTests

import XCTest
@testable import NewsApp

class NewsDetailTests: XCTestCase {

    var viewModel: NewsDetailViewModel!
    var article: Article!

    override func setUp() {
        super.setUp()
        // Create a sample article for testing
        article = createSampleArticle() // Adjust fields as per your Article model
        viewModel = NewsDetailViewModel(article: article)
    }

    override func tearDown() {
        viewModel = nil
        article = nil
        super.tearDown()
    }
    
    private func createSampleArticle(isBookmarked: Bool = false) -> Article {
        return Article(
            source: Source(id: "cbs-news", name: "CBS News"),
            author: "Chilekasi Adele, Ricky Sayer",
            title: "Trump holds rally at Arnold Palmer Regional Airport in Pennsylvania - CBS Pittsburgh",
            description: "Former President Donald Trump held a rally at the Arnold Palmer Regional Airport in Westmoreland County on Saturday evening.",
            url: "https://www.cbsnews.com/pittsburgh/news/donald-trump-rally-in-latrobe/",
            urlToImage: "https://assets3.cbsnewsstatic.com/hub/i/r/2024/10/19/09318182-2792-49fd-85c0-0c95dbc8cf2f/thumbnail/1200x630/4ca467157118c285037f9477d12f9cb2/gettyimages-2178641176.jpg?v=edba3a63b5392b4c81ae19d894992d91",
            publishedAt: "2024-10-20T02:12:20Z",
            content: "UNITY TOWNSHIP, Pa. (KDKA) — Former President Donald Trump held a rally at the Arnold Palmer Regional Airport in Westmoreland County on Saturday evening.",
            isBookmarked: isBookmarked
        )
    }
    

    func testInitialization() {
        XCTAssertEqual(viewModel.article.title, article.title, "Article title should be set correctly upon initialization.")
        XCTAssertEqual(viewModel.article.url, article.url, "Article URL should be set correctly upon initialization.")
    }

    func testFormatDate() {
        // Valid date string
        let formattedDate = viewModel.formatDate("2024-10-21T12:00:00Z")
        let expectedDate = DateFormatter.localizedString(from: ISO8601DateFormatter().date(from: "2024-10-21T12:00:00Z")!, dateStyle: .medium, timeStyle: .none)
        XCTAssertEqual(formattedDate, expectedDate, "Formatted date should match the expected output for a valid date string.")
        
        // Invalid date string
        let invalidDate = viewModel.formatDate("invalid-date")
        XCTAssertEqual(invalidDate, "invalid-date", "Formatted date should return the original string for an invalid date.")
    }

    func testArticleURL() {
        // Valid article URL
        let url = viewModel.articleURL()
        XCTAssertEqual(url?.absoluteString, article.url, "Article URL should return a valid URL for a valid string.")
    }
}
