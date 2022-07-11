//
//  ContentView.swift
//  GraphQL
//
//  Created by Ran Helfer on 10/07/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var model = BooksModel()
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear(perform: {
                model.fetch()
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
