// # npm init
// # Is this OK? (yes) yes
// # npm i --save-dev nodemon
// # npm run devStart
// # Then visit http://localhost:7777/graphql
// # npm install -g graphql
// # npm install -g apollo
// # apollo schema:download --endpoint=http://localhost:5000/graphql schema.json

const authorsData = [
	{ id: 1, name: 'J. K. Rowling' },
	{ id: 2, name: 'J. R. R. Tolkien' },
	{ id: 3, name: 'Brent Weeks' }
]

const booksData = [
	{ id: 1, name: 'Harry Potter and the Chamber of Secrets', authorId: 1 },
	{ id: 2, name: 'Harry Potter and the Prisoner of Azkaban', authorId: 1 },
	{ id: 3, name: 'Harry Potter and the Goblet of Fire', authorId: 1 },
	{ id: 4, name: 'The Fellowship of the Ring', authorId: 2 },
	{ id: 5, name: 'The Two Towers', authorId: 2 },
	{ id: 6, name: 'The Return of the King', authorId: 2 },
	{ id: 7, name: 'The Way of Shadows', authorId: 3 },
	{ id: 8, name: 'Beyond the Shadows', authorId: 3 }
]


const express = require('express')
const expressGraphQL = require('express-graphql').graphqlHTTP
const {
	GraphQLSchema,
	GraphQLObjectType,
	GraphQLString,
	GraphQLList,
	GraphQLInt,
	GraphQLNonNull
} = require('graphql')
const app = express()

const AuthorType = new GraphQLObjectType({
  name: 'Author',
  description: 'This represents an author of a book',
  fields: () => ({
    id: { type: GraphQLNonNull(GraphQLInt) },
    name: { type: GraphQLNonNull(GraphQLString) },
    books: {
      type: new GraphQLList(BookType),
      resolve: (author) => {
        return booksData.filter(book => book.authorId === author.id)
      }
    }
  })
})

const BookType = new GraphQLObjectType({
  name: 'Book',
  description: 'This represents a book written by an author',
  fields: () => ({
    id: { type: GraphQLNonNull(GraphQLInt) },
    name: { type: GraphQLNonNull(GraphQLString) },
    authorId: { type: GraphQLNonNull(GraphQLInt) },
    author: {
      type: AuthorType,
      resolve: (book) => {
        return authorsData.find(author => author.id === book.authorId)
      }
    }
  })
})

const RootQueryType = new GraphQLObjectType({
	name: 'Query',
	description: 'Root Query',
	fields: () => ({
		singleBook: {
			type: BookType,
			description: 'Single book data',
			args: {
				bookSearchId: { type: GraphQLInt }
			},
			resolve: (parent, args) => booksData.find(book => book.id === args.bookSearchId)
		},

		books: {
			type: new GraphQLList(BookType),
			description: 'List of all books',
			resolve: () => booksData
		},
		authors: {
			type: new GraphQLList(AuthorType),
			description: 'List of all authors',
			resolve: () => authorsData
		}
	})
})

const RootMutationType = new GraphQLObjectType({
  name: 'Mutation',
  description: 'Root Mutation',
  fields: () => ({
    addBook: {
      type: BookType,
      description: 'Add a book',
      args: {
        name: { type: GraphQLNonNull(GraphQLString) },
        authorId: { type: GraphQLNonNull(GraphQLInt) }
      },
      resolve: (parent, args) => {
        const book = { id: booksData.length + 1, name: args.name, authorId: args.authorId }
        booksData.push(book)
        return book
      }
    },
    addAuthor: {
      type: AuthorType,
      description: 'Add an author',
      args: {
        name: { type: GraphQLNonNull(GraphQLString) }
      },
      resolve: (parent, args) => {
        const author = { id: authorsData.length + 1, name: args.name }
        authorsData.push(author)
        return author
      }
    }
  })
})

const schema = new GraphQLSchema({
	query: RootQueryType,
	mutation: RootMutationType
})


app.use('/graphql', expressGraphQL({
  schema: schema,
  graphiql: true
}))
app.listen(7777, () => console.log('Server Running'))

