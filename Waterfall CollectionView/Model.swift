//
//  Model.swift
//  Waterfall CollectionView
//
//  Created by Alley Pereira on 22/07/21.
//

import Foundation

struct Model: Decodable {
    let message: [String]
}

class APICaller {

    static let shared = APICaller()

    public func getData(completionHandler: @escaping (Model) -> Void) {
        let urlString = "https://dog.ceo/api/breeds/image/random/50"
        let url = URL(string: urlString)

        URLSession.shared.dataTask(with: url!) { data, _, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let postData = try JSONDecoder().decode(Model.self, from: data)
                        completionHandler(postData)
                    } catch {
                        let error = error
                        print(error)
                    }
                }
            }
        }.resume()
    }
}
