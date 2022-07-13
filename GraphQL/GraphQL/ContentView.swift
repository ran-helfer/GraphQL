//
//  ContentView.swift
//  GraphQL
//
//  Created by Ran Helfer on 10/07/2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model = BooksModel()
    
    var body: some View {
        if model.bookList == nil {
            Text("Downloading...")
            .padding()
            .onAppear(perform: {
                model.fetch()
            })
        } else {
            if let books = model.bookList?.books  {
                List {
                    ForEach(books) { book in
                        VStack(alignment: .leading) {
                            Text(book.name)
                                .fontWeight(.light)
                            Text(book.author.name)
                                .fontWeight(.thin)
                                .foregroundColor(.gray)
                            Spacer(minLength: 8)
                        }
                    }
                    Button("Download Books") {
                        model.fetch()
                    }.foregroundColor(.blue)
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
