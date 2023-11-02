//
//  Movie+CoreDataProperties.swift
//  CoreDataFavoriteMovies
//
//  Created by Everett Brothers on 11/1/23.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var imdbID: String?
    @NSManaged public var posterURLString: String?

}

extension Movie : Identifiable {

}
