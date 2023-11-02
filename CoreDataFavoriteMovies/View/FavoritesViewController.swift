//
//  FavoritesViewController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/3/22.
//

import UIKit

class FavoritesViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let fetch = Movie.fetchRequest()
        movies = try! PersistenceController.shared.viewContext.fetch(fetch)
        tableView.reloadData()
    }
    
    func fetchFavorites() {
        let searchString = searchBar.text ?? ""
        movies = MovieController.shared.fetchFavorites(with: searchString)
        tableView.reloadData()
    }
    
    func removeFavorite(_ movie: Movie, for indexPath: IndexPath) {
        MovieController.shared.unFavoriteMovie(movie)
        let index = movies.firstIndex(of: movie)!
        movies.remove(at: index)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeFavorite(movies[indexPath.row], for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoreTableViewCell
        let movie = movies[indexPath.row]
        cell.nameLabel.text = movie.title
        cell.yearLabel.text = movie.year
        loadImage(url: movie.posterURL!, for: cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func loadImage(url: URL, for cell: CoreTableViewCell) {
        Task {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return
            }
            DispatchQueue.main.async {
                cell.cellImage.image = UIImage(data: data)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
}

extension FavoritesViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.isEmpty {
            fetchFavorites()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchFavorites()
    }
}



extension [Movie] {
    func toApiMovie() -> [APIMovie] {
        var apiMovies = [APIMovie]()
        for movie in self {
            apiMovies.append(movie.toApiMovie())
        }
        return apiMovies
    }
}
