# frozen_string_literal: true

require "qdrant"

module Vectorsearch
  class Qdrant < Base
    def initialize(
      url:,
      api_key:,
      index_name:,
      llm:,
      llm_api_key:
    )
      @client = ::Qdrant::Client.new(
        url: url,
        api_key: api_key
      )
      @index_name = index_name

      super(llm: llm, llm_api_key: llm_api_key)
    end

    # Add a list of texts to the index
    # @param texts [Array] The list of texts to add
    # @return [Hash] The response from the server
    def add_texts(
      texts:
    )
      batch = { ids: [], vectors: [], payloads: [] }

      texts.each do |text|
        batch[:ids].push(SecureRandom.uuid)
        batch[:vectors].push(generate_embedding(text: text))
        batch[:payloads].push({ content: text })
      end

      client.points.upsert(
        collection_name: index_name,
        batch: batch
      )
    end

    # Create the index with the default schema
    # @return [Hash] The response from the server
    def create_default_schema
      client.collections.create(
        collection_name: index_name,
        vectors: {
          distance: DEFAULT_METRIC.capitalize,
          size: default_dimension
        }
      )
    end

    def similarity_search(
      query:,
      k: 4
    )
      embedding = generate_embedding(text: query)

      similarity_search_by_vector(
        embedding: embedding,
        k: k
      )
    end

    def similarity_search_by_vector(
      embedding:,
      k: 4
    )
      client.points.search(
        collection_name: index_name,
        limit: k,
        vector: embedding,
        with_payload: true
      )
    end

    def ask(question:)
      search_results = similarity_search(query: question)

      context = search_results.dig("result").map do |result|
        result.dig("payload").to_s
      end
      context = context.join("\n---\n")

      prompt = generate_prompt(question: question, context: context)

      generate_completion(prompt: prompt)
    end
  end
end