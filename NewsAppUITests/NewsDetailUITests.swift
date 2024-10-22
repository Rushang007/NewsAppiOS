//
//  NewsDetailUITests.swift
//  NewsAppUITests

import XCTest
import SwiftUI

@testable import NewsApp


class NewsDetailUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Continue after failure
        continueAfterFailure = false
        
        // Initialize XCUIApplication
        app = XCUIApplication()
        app.launch()
    }

    func testNewsDetailViewUI() {
        // Launch the app
        //app.launch()
        let articalPreTitle =  "Packers vs Texans in winter warning"
        
        let articalPreDescription = "It's a white out at Lambeau Field today"
        
        let articalLinkTitle = "Read Full Article"
        
        // Assuming the article list is on the first screen and you tap on an article to see details
        let articleCell = app.cells.element(boundBy: 0)  // Access the first article cell
        XCTAssertTrue(articleCell.exists, "The article cell should be visible")
        articleCell.tap()  // Tap on the article to navigate to NewsDetailView
        
        // Check if the detail view has the title
        let articleTitle = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", articalPreTitle)).element
        // Adjust the identifier to match your app's title
        XCTAssertTrue(articleTitle.exists, "The article title should be visible in the detail view")
        
        // Check if the description exists (if available)
        let articleDescription = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", articalPreDescription)).element // Adjust the identifier
        
        XCTAssertTrue(articleDescription.exists, "The article description should be visible")
        
        //Scroll down
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "The scroll view should be visible")
        scrollView.swipeUp()
        
        // Verify the "Read Full Article" link is present
        let readFullArticleLink = app.buttons[articalLinkTitle]
        XCTAssertTrue(readFullArticleLink.exists, "The 'Read Full Article' link should be visible")
    }

}
