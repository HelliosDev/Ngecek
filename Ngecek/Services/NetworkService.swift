//
//  NetworkService.swift
//  Ngecek
//
//  Created by Wendy Kurniawan on 03/09/20.
//  Copyright © 2020 Wendy Kurniawan. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    func fetch(name: String, completion: @escaping(Batik?, Error?) -> Void) {
        
        var urlString: URLComponents {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "id.wikipedia.org"
            urlComponents.path = "/w/api.php"
            urlComponents.setQueryItems(with: [
                "format": "json",
                "action": "query",
                "prop": "extracts",
                "exintro": "",
                "explaintext": "",
                "indexpageids": "",
                "redirects": "1",
                "titles": name
            ])
            return urlComponents
        }
        
        guard let url = urlString.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                completion(nil, err)
                print(err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let batik = try JSONDecoder().decode(Batik.self, from: data)
                DispatchQueue.main.async {
                    completion(batik, nil)
                }
            } catch {
                print("Decoding Failed, \(error)")
            }
        }
        
        task.resume()
    }
}

extension URLComponents {
    fileprivate mutating func setQueryItems(with params: [String: String]) {
        self.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
