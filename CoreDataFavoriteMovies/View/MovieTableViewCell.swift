//
//  MovieTableViewCell.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 10/31/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MovieTableViewCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!

    var onFavorite: (() -> Void)?
    
    private var apiMovie: APIMovie?
    
    var heart = UIImage(systemName: "heart")
    var favoritedHeart = UIImage(systemName: "heart.fill")
    private let placeholder = UIImage(named: "moviePlaceholder")
    
    func update(with movie: Movie, onFavorite: (() -> Void)?) {
        self.apiMovie = movie.toApiMovie()
        self.onFavorite = onFavorite
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        if let url = movie.posterURL {
            Task {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                    return
                }
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    func update(with movie: APIMovie, onFavorite: (() -> Void)?) {
        self.apiMovie = movie
        self.onFavorite = onFavorite
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        if let url = movie.posterURL {
            Task {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                    return
                }
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            }
        }
    }

    func setFavorite() {
        heartButton.setImage(favoritedHeart, for: .normal)
        heartButton.tintColor = .red
    }
    
    func setUnFavorite() {
        heartButton.setImage(heart, for: .normal)
        heartButton.tintColor = .gray
    }
    
    @IBAction func favoriteButtonPressed() {
        onFavorite?()
    }
    
}
