# -*- encoding: utf-8 -*-
# stub: vectorsearch 0.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "vectorsearch".freeze
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/andreibondarev/vectorsearch/CHANGELOG.md", "homepage_uri" => "https://github.com/andreibondarev/vectorsearch", "source_code_uri" => "https://github.com/andreibondarev/vectorsearch" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andrei Bondarev".freeze]
  s.bindir = "exe".freeze
  s.date = "2023-05-01"
  s.description = "Vector Search backed by your vector search DB of choice.".freeze
  s.email = ["andrei.bondarev13@gmail.com".freeze]
  s.files = [".rspec".freeze, "CHANGELOG.md".freeze, "Gemfile".freeze, "Gemfile.lock".freeze, "LICENSE.txt".freeze, "README.md".freeze, "Rakefile".freeze, "lib/vectorsearch.rb".freeze, "lib/vectorsearch/base.rb".freeze, "lib/vectorsearch/milvus.rb".freeze, "lib/vectorsearch/pinecone.rb".freeze, "lib/vectorsearch/qdrant.rb".freeze, "lib/vectorsearch/version.rb".freeze, "lib/vectorsearch/weaviate.rb".freeze, "sig/vectorsearch.rbs".freeze]
  s.homepage = "https://github.com/andreibondarev/vectorsearch".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.4.16".freeze
  s.summary = "Vector Search backed by your vector search DB of choice.".freeze

  s.specification_version = 4

  s.add_development_dependency(%q<pry-byebug>.freeze, ["~> 3.10.0"])
  s.add_development_dependency(%q<dotenv-rails>.freeze, ["~> 2.7.6"])
  s.add_runtime_dependency(%q<weaviate-ruby>.freeze, ["~> 0.8.0"])
  s.add_runtime_dependency(%q<qdrant-ruby>.freeze, ["~> 0.9.0"])
  s.add_runtime_dependency(%q<tokenizers>.freeze, ["~> 0.3.3"])
  s.add_runtime_dependency(%q<ruby-openai>.freeze, ["~> 4.0.0"])
  s.add_runtime_dependency(%q<cohere-ruby>.freeze, ["~> 0.9.1"])
  s.add_runtime_dependency(%q<milvus>.freeze, ["~> 0.9.0"])
  s.add_runtime_dependency(%q<pinecone>.freeze, ["~> 0.1.6"])
end

