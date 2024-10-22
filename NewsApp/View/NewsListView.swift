//
//  NewsListView.swift
//  NewsApp

import SwiftUI

struct NewsListView: View {

    @EnvironmentObject var viewModel: NewsViewModel

    var body: some View {
        ZStack{
            NavigationStack {
                VStack {
                    CategoryDropdown(selectedCategory: $viewModel.selectedCategory) // Dropdown for category selection

                    List(viewModel.articles) { article in
                        // Navigation link to view full content
                        NavigationLink(destination:  NewsDetailView(viewModel: NewsDetailViewModel(article: article))) {
                            // Custom view to display title and description
                            NewsRowView(article: article)
                        }
                    }
                }
                
                .navigationTitle("News Articles")
                .onAppear {
                    // Fetch articles when the view appears
                    viewModel.fetchArticles(url: viewModel.createURL())
                }
            }
            LoadingView(isLoading: viewModel.isLoading)
        }
    }
}
