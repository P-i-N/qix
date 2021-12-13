-------------------------------------------------------------------------------
function SetupWorkspace(name)
	workspace(name)

	-- Premake output folder
	location(path.join(".build", _ACTION))

	-- Target architecture
	architecture "x86_64"

	-- Configuration settings
	configurations { "Debug", "Release" }

	-- Debug configuration
	filter { "configurations:Debug" }
		defines { "DEBUG" }
		symbols "On"
		optimize "Off"

	-- Release configuration
	filter { "configurations:Release" }
		defines { "NDEBUG" }
		optimize "Speed"
		inlining "Auto"

	filter { "language:not C#" }
		defines { "_CRT_SECURE_NO_WARNINGS" }
		characterset ("MBCS")
		buildoptions { "/std:c++latest" }

	filter { }
		targetdir ".bin/%{cfg.longname}/"
		defines { "WIN32", "_AMD64_" }
		vectorextensions "AVX2"
end

-------------------------------------------------------------------------------
function vcpkg(triplet, packages, linkLibs)
	local pkgList, errLevel = os.outputof("vcpkg list")

	for i, pkgName in ipairs(packages) do
		if pkgList:find(pkgName .. ":" .. triplet, 1, true) == nil then
			print("Installing vcpkg package " .. pkgName .. ":" .. triplet .. "..." )
			if os.execute("vcpkg install " .. pkgName .. " --triplet " .. triplet) ~= 0 then
				print("Could not install vcpkg package " .. pkgName .. ":" .. triplet .. "!!!" )
			end
		end
	end

	includedirs { "$(VcpkgRoot)..\\" .. triplet .. "\\include" }

	for i, libName in ipairs(linkLibs) do
		links("$(VcpkgRoot)..\\" .. triplet .. "\\lib\\" .. libName)
	end
end
