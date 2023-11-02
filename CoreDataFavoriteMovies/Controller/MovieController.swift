//
//  MovieController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation

class MovieController {
    static let shared = MovieController()
    
    private let apiController = MovieAPIController()
    private var viewContext = PersistenceController.shared.viewContext
    
    func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
        return try await apiController.fetchMovies(with: searchTerm)
    }
    
    func fetchFavorites(with searchTerm: String?) -> [Movie] {
        let fetchRequest = Movie.fetchRequest()
        if let text = searchTerm, text != "" {
            fetchRequest.predicate = NSPredicate(format: "title contains[c] %@", text)
        }
        var movies: [Movie] = []
        do {
            movies = try viewContext.fetch(fetchRequest)
        } catch {
            print("failed to fetch movies")
        }
        return movies
    }
    
    func deleteAll() {
        let movies = try? viewContext.fetch(Movie.fetchRequest())
        if let movies = movies {
            let i = 0
            while i < movies.count {
                viewContext.delete(movies[i])
            }
            PersistenceController.shared.saveContext()
        }
    }
    
    func favoriteMovie(_ movie: APIMovie) {
        let newMovie = Movie(context: viewContext)
        newMovie.title = movie.title
        newMovie.imdbID = movie.imdbID
        newMovie.year = movie.year
        newMovie.posterURLString = movie.posterURL?.formatted()
        PersistenceController.shared.saveContext()
    }
    
    func unFavoriteMovie(_ movie: Movie) {
        PersistenceController.shared.viewContext.delete(movie)
        PersistenceController.shared.saveContext()
    }

    
}
