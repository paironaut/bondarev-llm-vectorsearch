# Vectorsearch
![Tests status](https://github.com/andreibondarev/vectorsearch/actions/workflows/ci.yml/badge.svg) [![Gem Version](https://badge.fury.io/rb/vectorsearch.svg)](https://badge.fury.io/rb/vectorsearch)

Vectorsearch library is an abstraction layer on top of many popular vector search databases. It is a modern ORM that allows developers to easily chunk data, generate embeddings, store, search, query and retrieve data from vector search databases. Vectorsearch offers a straight-forward DSL and abstracts away overly complicated machine learning/data science-specific configurations and concepts

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add vectorsearch

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install vectorsearch

## Usage

```ruby
require "vectorsearch"
```

List of currently supported vector search databases and features:

| Database | Querying           | Storage | Schema Management | Backups | Rails Integration | ??? |
| -------- |:------------------:| -------:| -----------------:| -------:| -----------------:| ---:|
| Weaviate | :white_check_mark: | WIP     | WIP               | WIP     |                   |     |
| Qdrant   | :white_check_mark: | WIP     | WIP               | WIP     |                   |     |
| Milvus   | :white_check_mark: | WIP     | WIP               | WIP     |                   |     |
| Pinecone | :white_check_mark: | WIP     | WIP               | WIP     |                   |     |

### Create an instance

Choose the LLM provider you'll be using (OpenAI or Cohere) and retrieve the API key.

Pick the vector search database you'll be using and instantiate the client:
```ruby
client = Vectorsearch::Weaviate.new(
    url: ENV["WEAVIATE_URL"],
    api_key: ENV["WEAVIATE_API_KEY"],
    llm: :openai, # or :cohere
    llm_api_key: ENV["OPENAI_API_KEY"]
)

# You can instantiate any other supported vector search database:
client = Vectorsearch::Milvus.new(...)
client = Vectorsearch::Qdrant.new(...)
client = Vectorsearch::Pinecone.new(...)
```

```ruby
# Creating the default schema
client.create_default_schema
```

```ruby
# Store your documents in your vector search database
client.add_texts(
    texts: [
        "Begin by preheating your oven to 375°F (190°C). Prepare four boneless, skinless chicken breasts by cutting a pocket into the side of each breast, being careful not to cut all the way through. Season the chicken with salt and pepper to taste. In a large skillet, melt 2 tablespoons of unsalted butter over medium heat. Add 1 small diced onion and 2 minced garlic cloves, and cook until softened, about 3-4 minutes. Add 8 ounces of fresh spinach and cook until wilted, about 3 minutes. Remove the skillet from heat and let the mixture cool slightly.",
        "In a bowl, combine the spinach mixture with 4 ounces of softened cream cheese, 1/4 cup of grated Parmesan cheese, 1/4 cup of shredded mozzarella cheese, and 1/4 teaspoon of red pepper flakes. Mix until well combined. Stuff each chicken breast pocket with an equal amount of the spinach mixture. Seal the pocket with a toothpick if necessary. In the same skillet, heat 1 tablespoon of olive oil over medium-high heat. Add the stuffed chicken breasts and sear on each side for 3-4 minutes, or until golden brown."
    ]
)
```

```ruby
# Retrieve similar documents based on the query string passed in
client.similarity_search(
    query:,
    k:       # number of results to be retrieved
)
```
```ruby
# Retrieve similar documents based on the embedding passed in
client.similarity_search_by_vector(
    embedding:,
    k:       # number of results to be retrieved
)
```
```ruby
# Q&A-style querying based on the question passed in
client.ask(
    question:
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andreibondarev/vectorsearch.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
