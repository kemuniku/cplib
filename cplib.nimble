# Package

version       = "1.0"
author        = "kemuniku"
description   = "A new awesome nimble package"
license       = "CC0"
srcDir        = "src"
skipDirs      = @["verify", ".verify-helper", "docs"]

backend       = "cpp"

# Dependencies

requires "nim >= 1.6.14", "https://github.com/zer0-star/Nim-ACL >= 0.1.0"
