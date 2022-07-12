//
//  Network.swift
//  GraphQL
//
//  Created by Ran Helfer on 11/07/2022.
//

import Foundation
import Apollo

class Network {
    static let shared = Network()
    let url = "http://localhost:5555/graphql"
    
    private(set) lazy var apollo = ApolloClient(url: URL(string: url)!)
    
    
}


class BooksModel: ObservableObject {
    @Published var books: [Book] = []
    
    init() {
        fetch()
    }
    
    func fetch() {
        Network.shared.apollo.fetch(query: BooksListQuery()) { [weak self] result in
            switch result {
            case .success(let graphQLObject):
                self?.process(data: graphQLObject.data)
            case .failure(let error):
                print("error is \(error)")

            }
        }
    }
    
    func process(data: BooksListQuery.Data?) {
        guard let data = data else { return }
        /* Seem like we get the data from the local server ok */
        print(data)
    }
}

//struct Books {
//
//    var books: [Book]
//
//    init(_ graphQLData: booksData?) {
//       /// self.books = graphQLData?.map
//    }
//}

typealias booksData = BooksListQuery.Data.Book

struct Author: Decodable {
    let id: Int
    let name: String
    let authorId: String
}

struct Book: Decodable {
    let id: Int
    let name: String
    let author: Author
}
