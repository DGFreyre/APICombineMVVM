//
//  MovieViewModel.swift
//  CombineAPIMovies
//
//  Created by DGF on 4/3/23.
//

import Foundation
import Combine

class MovieViewModel : ObservableObject {
    
   var movieAPI = MovieStore.shared
   @Published var movies : [Movie] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    func fetchMovies(){
        self.movieAPI.fetchMovies(from: .nowPlaying)
            .sink { [unowned self] (completion) in
                
            } receiveValue: { [unowned self] movies in
                self.movies = movies
            }
        .store(in: &self.subscriptions)
    }
}

