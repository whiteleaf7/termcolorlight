# -*- coding: utf-8 -*-
#
# Copyright 2014 whiteleaf. All rights reserved.
#

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'termcolorlight'

Gem::Specification.new do |spec|
  spec.name          = "termcolorlight"
  spec.version       = TermColorLight::VERSION
  spec.authors       = ["whiteleaf7"]
  spec.email         = ["2nd.leaf@gmail.com"]
  spec.summary       = "convert color tags to ansicolor library"
  spec.description = <<-EOS
This gem is library that convert color tags (e.g. <red>str</red>) to
ansicolor(vt100 escape sequence). And this's lightweight version of
TermColor.gem without other gems. In addition process spedd is surprisingly fast.
  EOS
  spec.homepage      = "http://github.com/whiteleaf7/termcolorlight"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end

