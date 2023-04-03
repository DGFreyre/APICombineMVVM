//
//  MovieStore .swift
//  CombineAPIMovies
//
//  Created by DGF on 4/3/23.
//

import Foundation
import Combine

public class MovieStore: MovieService {
    
    public static let shared = MovieStore()
    public init(){}
    private let urlSession = URLSession.shared
    private var subscriptions = Set<AnyCancellable>()
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    func fetchMovies(from endpoint: Endpoint) -> Future<[Movie], MovieStoreAPIError> {
        return Future<[Movie],MovieStoreAPIError> { [unowned self] response in
            guard let url = self.generateURL(with: endpoint) else{
                return response(.failure(.urlError(URLError(URLError.unsupportedURL))))
            }
            self.urlSession.dataTaskPublisher(for: url)
                .tryMap { (data, result) -> Data in
                    guard let httpResponse = result as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw MovieStoreAPIError.responseError((result as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                }
                .decode(type: MoviesResponse.self, decoder: self.jsonDecoder)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let urlError as URLError:
                            response(.failure(.urlError(urlError)))
                        case let decodingError as DecodingError:
                            response(.failure(.decodingError(decodingError)))
                        case let apiError as MovieStoreAPIError:
                            response(.failure(apiError))
                        default:
                            response(.failure(.genericError))
                        }
                    }
                
                }, receiveValue: {response(.success($0.results)) })
                .store(in: &self.subscriptions)
        }
    }
    
    private func generateURL(with endpoint: Endpoint) -> URL? {
        guard var urlComponents = URLComponents(string: "\(K.baseURL)/movie/\(endpoint.rawValue)") else {
            return nil
        }
        let queryItems = [URLQueryItem(name: "api_key", value: K.apiKey)]
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}
