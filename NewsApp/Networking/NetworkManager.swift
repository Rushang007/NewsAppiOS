//
//  NetworkManager.swift
//  NewsApp


import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    init() {}

    // Sends a network request to the given URL with an HTTP method and optional parameters, then decodes the response into a specific type (T) or returns an error.
    func request<T: Decodable>(
        url: URL,
        httpMethod: HTTPMethod,
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        // Set request body and headers if parameters are provided
        configureRequest(&request, parameters: parameters)

        printRequestDetails(request: request, url: url, httpMethod: httpMethod)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            // Ensure the response is an HTTPURLResponse
            guard let _ = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                return
            }

            // Check if the response contains data
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            // Handle decoding the response data
            self.handleResponse(data: data, completion: completion)
        }
        task.resume()
    }

    // Helper function to call `request` with provided URL, HTTP method, and parameters, returning the result or an error.
    func performRequest<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        parameters: [String: Any] = [:],
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        request(url: url, httpMethod: method, parameters: parameters, completion: completion)
    }

    // MARK: - Private Methods
    
    // Sets the request body and headers, converting parameters to JSON if provided.
    private func configureRequest(_ request: inout URLRequest, parameters: [String: Any]?) {
        guard let parameters = parameters, !parameters.isEmpty else { return }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print("Error serializing parameters: \(error)")
        }
    }

    // Decodes the server response into the specified type (T) or returns a decoding error. Also prints the response for debugging.
    private func handleResponse<T: Decodable>(data: Data, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            // Debugging response
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Response: \(jsonString)")
            }
            
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedObject))
        } catch {
            completion(.failure(.decodingError))
        }
    }

    // Prints the URL, HTTP method, parameters, and headers for debugging purposes.
    private func printRequestDetails(request: URLRequest, url: URL, httpMethod: HTTPMethod) {
        print("URL: \(url)")
        print("HTTP Method: \(httpMethod)")
        print("Parameters: \(String(describing: request.httpBody))")
        print("Headers: \(String(describing: request.allHTTPHeaderFields))")
    }
}
