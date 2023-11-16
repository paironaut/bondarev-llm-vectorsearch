# frozen_string_literal: true

require "weaviate"

module Vectorsearch
  class Weaviate < Base
    def initialize(
      url:,
      api_key:,
      index_name:,
      llm:,
      llm_api_key:
    )
      @client = ::Weaviate::Client.new(
        url: url,
        api_key: api_key,
        model_service: llm,
        model_service_api_key: llm_api_key
      )
      @index_name = index_name

      super(llm: llm, llm_api_key: llm_api_key)
    end

    def add_texts(
      texts:
    )
      objects = []  
      texts.each do |text|
        objects.push({
          class_name: index_name,
          properties: {
            content: text
          }
        })
      end

      client.objects.batch_create(
        objects: objects
      )
    end

    def create_default_schema
      client.schema.create(
        class_name: index_name,
        vectorizer: "text2vec-#{llm.to_s}",
        properties: [
          {
            dataType: ["text"],
            name: "content"
          }
        ]
      )
    end

    # Return documents similar to the query
    # @param query [String] The query to search for
    # @param k [Integer|String] The number of results to return
    # @return [Hash] The search results
    def similarity_search(
      query:,
      k: 4
    )
      near_text = "{ concepts: [\"#{query}\"] }"

      client.query.get(
        class_name: index_name,
        near_text: near_text,
        limit: k.to_s,
        fields: "content _additional { id }"
      )
    end

    # Return documents similar to the vector
    # @param embedding [Array] The vector to search for
    # @param k [Integer|String] The number of results to return
    # @return [Hash] The search results
    def similarity_search_by_vector(
      embedding:,
      k: 4
    )
      near_vector = "{ vector: #{embedding} }"

      client.query.get(
        class_name: index_name,
        near_vector: near_vector,
        limit: k.to_s,
        fields: "content recipe_id"
      )
    end

    # Ask a question and return the answer
    # @param question [String] The question to ask
    # @return [Hash] The answer
    def ask(
      question:
    )
      # Weaviate currently supports the `ask:` parameter only for the OpenAI LLM (with `qna-openai` module enabled).
      if llm == :openai
        ask_object = "{ question: \"#{question}\" }"

        client.query.get(
          class_name: index_name,
          ask: ask_object,
          limit: "1",
          fields: "_additional { answer { result } }"
        )
      elsif llm == :cohere
        search_results = similarity_search(query: question)

        context = search_results.map do |result|
          result.dig("content").to_s
        end
        context = context.join("\n---\n")

        prompt = generate_prompt(question: question, context: context)

        generate_completion(prompt: prompt)
      end
    end
  end
end