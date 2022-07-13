//
//  NetworkManager.swift
//  VKTest
//
//  Created by Сергей Николаев on 13.07.2022.
//

import Foundation

protocol NetworkManagerDescription {
    func loadServices(urlString: String, completion: @escaping (Result<Request, Error>) -> Void)
}

enum NetworkError: Error {
    case invalidUrl
    case emptyData
}

final class NetworkManager: NetworkManagerDescription {
    static let shared = NetworkManager()
    
    private init() {}
    
    
    func loadServices(urlString: String, completion: @escaping (Result<Request, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        let request = URLRequest(url: url)
            
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.emptyData))
                return
            }

            let decoder = JSONDecoder()
            
            do {
                let res = try decoder.decode(Request.self, from: data)
                completion(.success(res))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}
