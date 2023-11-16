# frozen_string_literal: true

require_relative "vectorsearch/version"

module Vectorsearch
  class Error < StandardError; end

  autoload :Base, "vectorsearch/base"
  autoload :Milvus, "vectorsearch/milvus"
  autoload :Pinecone, "vectorsearch/pinecone"
  autoload :Qdrant, "vectorsearch/qdrant"
  autoload :Weaviate, "vectorsearch/weaviate"
end
