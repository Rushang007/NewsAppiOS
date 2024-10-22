//
//  LoadingView.swift
//  NewsApp

import SwiftUI

struct LoadingView: View {
    var isLoading: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if isLoading {
            ZStack {
                Color.black.opacity(0.3)
                                    .edgesIgnoringSafeArea(.all)
                ProgressView()
                    .tint(.white)
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5, anchor: .center)
                    .padding()
            }
        }
    }
}
