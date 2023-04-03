//
//  Movie.swift
//  CombineAPIMovies
//
//  Created by DGF on 4/2/23.
//

import Foundation

public struct MoviesResponse : Codable {
    public let page: Int
    public let totalResults: Int
    public let totalPages: Int
    public let results: [Movie]
}

public struct Movie : Codable, Equatable, Hashable {
    
    public let id: Int
    public let title: String
    public let backdropPath: String?
    public let posterPath: String?
    public let overview: String
    public let releaseDate: Date
    public let voteAverage: Double
    public let voteCount: Int
    public let tagline: String?
    public let adult: Bool
    public let runtime: Int?
 
}
