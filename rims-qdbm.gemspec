#-*-  coding: utf-8 -*-

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rims/qdbm/version"

Gem::Specification.new do |spec|
  spec.name          = "rims-qdbm"
  spec.version       = RIMS::QDBM::VERSION
  spec.authors       = ["TOKI Yoshinori"]
  spec.email         = ["toki@freedom.ne.jp"]

  spec.summary       = %q{RIMS key-value store plug-in for QDBM}
  spec.description   = <<-'EOF'
    RIMS key-value store plug-in for QDBM.  By introducing this
    plug-in, RIMS IMAP server will be able to store mailboxes and
    messages in QDBM.  QDBM is Quick Database Manager of
    https://fallabs.com/qdbm/.
  EOF
  spec.homepage      = "https://github.com/y10k/rims-qdbm"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rims", ">= 0.2.2"
  spec.add_runtime_dependency "ruby-qdbm"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit"
end

# Local Variables:
# mode: Ruby
# indent-tabs-mode: nil
# End:
