//
//  NetworkManager.swift
//  H4X0R News
//
//  Created by Mateusz Sarnowski on 27/04/2020.
//  Copyright © 2020 Mateusz Sarnowski. All rights reserved.
//

import Foundation

class NetworkManager: ObservableObject {
    
    @Published var posts = [Post]()
    
    func fetchData() {
        if let url = URL(string: "http://hn.algolia.com/api/v1/search?tags=front_page") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let safeError = error {
                    print(safeError)
                } else if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let results = try decoder.decode(Results.self, from: safeData)
                        DispatchQueue.main.async {
                            self.posts = results.hits
                        }
                    } catch {
                        print(error)
                    }
                    
                }
            }
            task.resume()
        }
    }
}
