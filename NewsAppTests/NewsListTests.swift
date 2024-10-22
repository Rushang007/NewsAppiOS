//
//  NewsListTests.swift
//  NewsAppTests


import XCTest
@testable import NewsApp

class NewsListTests: XCTestCase {

    var viewModel: NewsViewModel!
    var mockNetworkManager: MockNetworkManager!


    override func setUpWithError() throws {
        super.setUp()
      
        viewModel = NewsViewModel()
        UserDefaults.standard.removeObject(forKey: "bookmarkedArticles") // Clear bookmarks before each test
    }

    override func tearDownWithError() throws {
        viewModel = nil
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
    
    // Test if the view model is initialized with an empty list of articles
    func testViewModelInitialization() {
        XCTAssertTrue(viewModel.articles.isEmpty, "Articles should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Loading state should be false initially")
    }

    // Test that bookmarks are loaded correctly from UserDefaults
    func testLoadBookmarks() {
        let sampleURL = "https://www.cbsnews.com/pittsburgh/news/donald-trump-rally-in-latrobe/"
        UserDefaults.standard.setValue([sampleURL], forKey: "bookmarkedArticles")
        let sampleArticle = createSampleArticle()
        viewModel.articles = [sampleArticle]
        
        viewModel.loadBookmarks()
        
        XCTAssertTrue(viewModel.articles[0].isBookmarked, "Article should be marked as bookmarked after loading")
    }

    // Test that bookmarking an article adds it to UserDefaults
    func testBookmarkArticle() {
        let sampleArticle = createSampleArticle()
        viewModel.articles = [sampleArticle]
        
        viewModel.bookmarkArticle(sampleArticle)
        
        let bookmarks = UserDefaults.standard.stringArray(forKey: "bookmarkedArticles") ?? []
        XCTAssertTrue(bookmarks.contains(sampleArticle.url), "Bookmark should be added to UserDefaults")
        XCTAssertTrue(viewModel.articles[0].isBookmarked, "Article should be marked as bookmarked")
    }

    // Test removing a bookmark
    func testRemoveBookmark() {
        let sampleURL = "https://www.cbsnews.com/pittsburgh/news/donald-trump-rally-in-latrobe/"
        UserDefaults.standard.setValue([sampleURL], forKey: "bookmarkedArticles")
        
        let sampleArticle = createSampleArticle(isBookmarked: true)
        viewModel.articles = [sampleArticle]
        
        viewModel.removeBookmark(sampleArticle)
        
        let bookmarks = UserDefaults.standard.stringArray(forKey: "bookmarkedArticles") ?? []
        XCTAssertFalse(bookmarks.contains(sampleArticle.url), "Bookmark should be removed from UserDefaults")
        XCTAssertFalse(viewModel.articles[0].isBookmarked, "Article should not be marked as bookmarked")
    }

    // Test that changing the category triggers fetching articles
    func testUpdateSelectedCategory() {
        // Create an expectation for the fetchArticles completion
        let expectation = self.expectation(description: "Articles should be fetched")
        
        // Set an observer on the `isLoading` or `articles` property to detect when articles are fetched
        let observation = viewModel.$isLoading.sink { isLoading in
            // Once loading completes, fulfill the expectation
            if !isLoading {
                expectation.fulfill()
            }
        }
        
        // Update the category, which should trigger fetchArticles
        viewModel.updateSelectedCategory(.business)
        
        // Wait for the expectation to be fulfilled (i.e., articles have been fetched)
        waitForExpectations(timeout: 5.0)
        
        // Check if the selected category has been updated correctly
        XCTAssertEqual(viewModel.selectedCategory, .business, "Selected category should update")
        
        // Cancel the observation to avoid memory leaks
        observation.cancel()
    }

    func testFetchArticlesSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for fetchArticles to Success")
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=general&apiKey=334c8bad7d324c52ba909c2ee44138a8")

        // When
        self.viewModel.fetchArticles(url: url) { errorMsg in
            // Then
            XCTAssertNil(errorMsg)
            XCTAssertGreaterThan(self.viewModel.articles.count, 0)
            expectation.fulfill()  // Fulfill the expectation when the error message is received
        }

        // Wait for expectations
        wait(for: [expectation], timeout: 5.0)  // Wait for the expectation to be fulfilled
    }
    
    func testFetchArticlesFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for fetchArticles to fail")
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=general")

        // When
        self.viewModel.fetchArticles(url: url) { errorMsg in
            // Then
            XCTAssertEqual(errorMsg, "Your API key is missing. Append this to the URL with the apiKey param, or use the x-api-key HTTP header.", "apiKey param")
            expectation.fulfill()  // Fulfill the expectation when the error message is received
        }

        // Wait for expectations
        wait(for: [expectation], timeout: 5.0)  // Wait for the expectation to be fulfilled
    }
    
    func testInvalidURL() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for URL to fail")
        let url = URL(string: "http") // Invalid URL

        // When
        self.viewModel.fetchArticles(url: url) { errorMsg in
            // Then
            XCTAssertEqual(errorMsg, "unsupported URL", "Expected error message for invalid URL.")
            expectation.fulfill()  // Fulfill the expectation when the error message is received
        }

        // Wait for expectations
        wait(for: [expectation], timeout: 5.0)  // Wait for the expectation to be fulfilled
    }
    
    func testOtherURL() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for URL to fail")
        let url = URL(string: "https://www.test.com") // Invalid URL

        // When
        self.viewModel.fetchArticles(url: url) { errorMsg in
            // Then
            XCTAssertEqual(errorMsg, APIError.decodingError.localizedDescription)
            expectation.fulfill()  // Fulfill the expectation when the error message is received
        }

        // Wait for expectations
        wait(for: [expectation], timeout: 5.0)  // Wait for the expectation to be fulfilled
    }
    
    func testNilURLFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for fetchArticles to fail with nil URL")
        let url: URL? = nil // nil URL

        // When
        self.viewModel.fetchArticles(url: url) { errorMsg in
            // Then
            XCTAssertEqual(errorMsg, APIError.invalidURL.localizedDescription, "Expected error message for nil URL.")
            expectation.fulfill()  // Fulfill the expectation when the error message is received
        }

        // Wait for expectations
        wait(for: [expectation], timeout: 5.0)  // Wait for the expectation to be fulfilled
    }
}
