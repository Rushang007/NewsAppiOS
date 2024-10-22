//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by MTPC-405 on 18/10/24.
//

import SwiftUI

@main
struct NewsAppApp: App {
    @StateObject private var viewModel = NewsViewModel() // Initialize ViewModel

    var body: some Scene {
        WindowGroup {
            NewsListView()
                .environmentObject(viewModel)
        }
    }
}
