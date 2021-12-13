dofile "etc/PremakeUtils.lua"

SetupWorkspace "QIX"

includedirs { "libs", "src" }

project "qixconv"
	language "C++"
	kind "ConsoleApp"
	files { "src/qixconv/**.*", "src/qix/**.*" }

project "benchmark"
	language "C++"
	kind "ConsoleApp"
	files { "src/benchmark/**.*", "src/qix/**.*" }
	vcpkg("x64-windows-static", { "libpng", "zstd" }, { "libpng16", "zlib", "zstd_static" })
