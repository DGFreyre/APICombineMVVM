//
//  ContentView.swift
//  CombineAPIMovies
//
//  Created by DGF on 4/2/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieViewModel()
    var body: some View {
        VStack {
            List{
                ForEach(viewModel.movies, id: \.id) {
                    movie in
                    Text("\(movie.title)")
                }
            }.listStyle(.inset)
        }
        .onAppear{
            viewModel.fetchMovies()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
