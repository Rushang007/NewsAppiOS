//
//  APIError.swift
//  NewsApp


import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case decodingError
    case serverError(Int)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed(let error):
            return error.localizedDescription
        case .decodingError:
            return "Failed to decode the response."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
