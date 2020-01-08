Pod::Spec.new do |spec|

  spec.name         = "SDOSStencil"
  spec.version      = "0.0.1"
  spec.summary      = "Librería para la generación de código automatico usando ficheros .stencil"

  spec.homepage     = "https://github.com/SDOSLabs/SDOSStencil"

  spec.license      = { :type => 'MIT' }

  spec.authors      = 'SDOS'

  spec.platform     = :ios, '9.0'

  spec.source       = { :git => "https://github.com/SDOSLabs/SDOSStencil.git", :tag => "#{spec.version}" }

  spec.preserve_paths = "src/Templates/**"

  spec.dependency "Sourcery", "~> 0.17.0"

end
