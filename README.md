#  News Reader App

##Project Overview:

The News Reader App is a simple iOS application built using SwiftUI and follows the MVVM architecture. It fetches news articles from the NewsAPI and displays them in a user-friendly list format. Users can browse news articles, read full content, bookmark articles, and filter news by category.

##Features:

- **Browse Articles:** Display a list of news articles, each showing the title and summary (description).
- **Read Full Articles:** Users can tap on any article to see the full content in a detailed view.
- **Bookmarking:** Users can bookmark articles to read later. 
- **Filtering by Category:** Users can filter articles by categories (e.g., Technology, Business, Sports, etc.).

##Technical Stack

- **iOS:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel)
- **Networking:** URLSession for API calls
- **Data Persistence:** UserDefaults for saving bookmarked articles
- **API:** [News API](https://newsapi.org/)

##Setup and Configuration

1. Clone this repository.
2. Get an API key from News API by signing up.
3. Add your API key to the project:
     - Locate the Constants.swift file.
     - Replace YOUR_API_KEY with your actual API key in the apiKey constant.
4. Build and run the app in Xcode.

##Architecture and Implementation Choices

- **MVVM Architecture:** The app is built following the MVVM architecture to maintain separation of concerns and keep the code modular and testable.
- **Model:** Represents the article data and response from the News API.
- **ViewModel:** Handles business logic, API calls, data manipulation, and updates the view accordingly.
- **View:** SwiftUI views for UI components such as the article list, detail view, and bookmark section.
- **SwiftUI:** Used for building the user interface, ensuring that the app benefits from declarative UI programming.
- **Networking:** URLSession is used for making network calls to fetch articles. The response is decoded using the Codable protocol.
- **Bookmarking:** Implemented using UserDefaults to store articles that the user marks for later reading.

##Future Improvements:

- **Offline Mode:** Add offline storage with CoreData so users can read bookmarked articles without internet access.
- **Better Error Handling:** Improve error messages and provide options to retry when the app can't fetch data.
- **Pagination:** Load more articles as users scroll, improving performance and reducing memory use.

##UI Improvements:

- Enhance the app's visual design for a cleaner, more modern look.
- Ensure full support for Dark Mode.
- Add smooth animations for transitions between screens.
- Use custom fonts and icons for a unique style.
- Optimize the layout for all screen sizes, including iPhones and iPads.

## NewsApp

![](https://github.com/Rushang007/NewsAppiOS/blob/main/NewsApp.gif)
