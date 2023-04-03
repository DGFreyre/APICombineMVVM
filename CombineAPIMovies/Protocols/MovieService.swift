//
//  MovieService.swift
//  CombineAPIMovies
//
//  Created by DGF on 4/2/23.
//

import Foundation
import Combine


protocol MovieService {
    func fetchMovies(from endpoint: Endpoint) -> Future<[Movie], MovieStoreAPIError>
}
