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
    let url = "http://localhost:7777/graphql"
    
    private(set) lazy var apollo = ApolloClient(url: URL(string: url)!)
    
    
}


class BooksModel: ObservableObject {
    @Published var bookList: BooksList?
  
    func fetch() {
        
        bookList = nil
        
        Network.shared.apollo.fetch(query: BooksListQuery()) { [weak self] result in
            switch result {
            case .success(let graphQLObject):
                self?.process(booksData: graphQLObject.data)
            case .failure(let error):
                print("error is \(error)")

            }
        }
    }
    
    func process(booksData: BooksData?) {
        guard let booksData = booksData else { return }
        /* Seem like we get the data from the local server ok */
        print(booksData)
        bookList = BooksList(data: booksData)
    }
}

typealias BooksData = BooksListQuery.Data

struct BooksList {
    var books = [Book]()
    
    init(data: BooksData) {
        data.books?.forEach({ book in
        
            guard let book = book,
                  let bookAuthor = book.author else {
                return
            }

            let author = Author(name: bookAuthor.name, authorId: bookAuthor.id)
            let aBook = Book(id: book.id, name: book.name, author: author)
            books.append(aBook)
        })
    }
}

struct Author: Decodable {
    let name: String
    let authorId: Int
}

struct Book: Decodable, Identifiable {
    let id: Int
    let name: String
    let author: Author
}
