# frozen_string_literal: true

require_relative "lib/activerecord/transaction_subscriber/version"

Gem::Specification.new do |spec|
  spec.name = "activerecord-transaction_subscriber"
  spec.version = ActiveRecord::TransactionSubscriber::VERSION
  spec.authors = ["Ueda Satoshi"]
  spec.email = ["gunyoki@gmail.com"]

  spec.summary = "Log the execution time of ActiveRecord transactions."
  spec.description = "The number of queries executed in a transaction, the execution time, and the wall-clock time of the transaction are logged at the end of the transaction."
  spec.homepage = "https://github.com/gunyoki/activerecord-transaction_subscriber"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/gunyoki/activerecord-transaction_subscriber"
  spec.metadata["changelog_uri"] = "https://github.com/gunyoki/activerecord-transaction_subscriber/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "~> 5.0"
end
