# Package

version       = "0.0.0.0.0.0.0.0.0.0.0.0.0.1"
author        = "kemuniku"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
skipDirs      = @["verify", ".verify-helper"]

backend       = "cpp"

# Dependencies

requires "nim >= 1.6.14", "https://github.com/zer0-star/Nim-ACL >= 0.1.0"
