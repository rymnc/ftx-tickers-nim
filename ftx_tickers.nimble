# Package

version       = "0.1.0"
author        = "rymnc"
description   = "Collect ftx ticker data"
license       = "MIT"
srcDir        = "src"
bin           = @["ftx_tickers"]


# Dependencies

requires "nim >= 1.6.6"
requires "ws >= 0.5.0"
