# frozen_string_literal: true

require "openai"
require "cohere"

module Vectorsearch
  class Base
    attr_reader :client, :index_name, :llm, :llm_api_key

    DEFAULT_METRIC = "cosine".freeze
    DEFAULT_COHERE_DIMENSION = 1024
    DEFAULT_OPENAI_DIMENSION = 1536

    # Currently supported LLMs
    # TODO: Add support for HuggingFace
    LLMS = %i[openai cohere].freeze

    # @param llm [Symbol] The LLM to use
    # @param llm_api_key [String] The API key for the LLM
    def initialize(llm:, llm_api_key:)
      validate_llm!(llm: llm)

      @llm = llm
      @llm_api_key = llm_api_key
    end

    def create_default_schema
      raise NotImplementedError
    end

    # TODO
    def add_texts(texts:)
      raise NotImplementedError
    end

    # NotImplementedError will be raised if the subclass does not implement the `ask()` method
    def ask(question:)
      raise NotImplementedError
    end

    # Generate an embedding for a given text
    # Currently supports OpenAI and Cohere
    # The LLM-related method will most likely need to be abstracted out into a separate class
    # @param text [String] The text to generate an embedding for
    # @return [String] The embedding
    def generate_embedding(text:)
      case llm
      when :openai
        response = openai_client.embeddings(
          parameters: {
            model: "text-embedding-ada-002",
            input: text
          }
        )
        response.dig("data").first.dig("embedding")
      when :cohere
        response = cohere_client.embed(
          texts: [text],
          model: "small"
        )
        response.dig("embeddings").first
      end
    end

    # Generate a completion for a given prompt
    # Currently supports OpenAI and Cohere
    # The LLM-related method will most likely need to be abstracted out into a separate class
    # @param prompt [String] The prompt to generate a completion for
    # @return [String] The completion
    def generate_completion(prompt:)
      case llm
      when :openai
        response = openai_client.completions(
          parameters: {
            model: "text-davinci-003",
            temperature: 0.0,
            prompt: prompt
          }
        )
        response.dig("choices").first.dig("text")
      when :cohere
        response = cohere_client.generate(
          prompt: prompt,
          temperature: 0.0
        )
        response.dig("generations").first.dig("text")
      end
    end

    def generate_prompt(question:, context:)
      "Context:\n" +
      "#{context}\n" +
      "---\n" +
      "Question: #{question}\n" +
      "---\n" +
      "Answer:"
    end

    private

    def default_dimension
      if llm == :openai
        DEFAULT_OPENAI_DIMENSION
      elsif llm == :cohere
        DEFAULT_COHERE_DIMENSION
      end
    end

    def openai_client
      @openai_client ||= OpenAI::Client.new(access_token: llm_api_key)
    end

    def cohere_client
      @cohere_client ||= Cohere::Client.new(api_key: llm_api_key)
    end

    def validate_llm!(llm:)
      raise ArgumentError, "LLM must be one of #{LLMS}" unless LLMS.include?(llm)
    end
  end
end