//
//  MovieAPIController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation

class MovieAPIController {
    
    enum MovieError: Error, LocalizedError {
        case couldNotFindMovies
    }
    
    let baseURL = URL(string: "http://www.omdbapi.com/")!
    let apiKey = "1c3a360c"
    
    func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            "apikey": "\(apiKey)",
            "s": "\(searchTerm)",
            "r": "json"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw MovieError.couldNotFindMovies
        }
        let result = try JSONDecoder().decode(MovieResult.self, from: data)
        return result.Search
    }
    
}
