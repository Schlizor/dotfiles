return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		local cmake = require("cmake-tools")

		-- you can find the icons from https://github.com/Civitasv/runvim/blob/master/lua/config/icons.lua
		local icons = require("thomas.config.icons")

		-- Credited to [evil_lualine](https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/evil_lualine.lua)
		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		local colors = {
			blue = "#89b4fa",
			green = "#a6e3a1",
			violet = "#cba6f7",
			yellow = "#f9e2af",
			red = "#f38ba8",
			fg = "#c3ccdc",
			bg = "#1e1e2e",
			inactive_bg = "#2c3043",
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.semilightgray },
				c = { bg = colors.inactive_bg, fg = colors.semilightgray },
			},
		}

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = my_lualine_theme,
			},
			sections = {
				lualine_c = {

					{
						function()
							local c_preset = cmake.get_configure_preset()
							return "CMake: [" .. (c_preset and c_preset or "X") .. "]"
						end,
						icon = icons.ui.Search,
						cond = function()
							return cmake.is_cmake_project() and cmake.has_cmake_preset()
						end,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeSelectConfigurePreset")
								end
							end
						end,
					},
					{

						function()
							local type = cmake.get_build_type()
							return "CMake: [" .. (type and type or "") .. "]"
						end,
						icon = icons.ui.Search,
						cond = function()
							return cmake.is_cmake_project() and not cmake.has_cmake_preset()
						end,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeSelectBuildType")
								end
							end
						end,
					},
					{

						function()
							local kit = cmake.get_kit()
							return "[" .. (kit and kit or "X") .. "]"
						end,
						icon = icons.ui.Pencil,
						cond = function()
							return cmake.is_cmake_project() and not cmake.has_cmake_preset()
						end,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeSelectKit")
								end
							end
						end,
					},
					{

						function()
							return "Build"
						end,
						icon = icons.ui.Gear,
						cond = cmake.is_cmake_project,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeBuild")
								end
							end
						end,
					},
					{
						function()
							local b_preset = cmake.get_build_preset()
							return "[" .. (b_preset and b_preset or "X") .. "]"
						end,
						icon = icons.ui.Search,
						cond = function()
							return cmake.is_cmake_project() and cmake.has_cmake_preset()
						end,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeSelectBuildPreset")
								end
							end
						end,
					},
					{
						function()
							local b_target = cmake.get_build_target()
							return "[" .. (b_target and b_target or "X") .. "]"
						end,
						cond = cmake.is_cmake_project,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeSelectBuildTarget")
								end
							end
						end,
					},
					{
						function()
							return icons.ui.Debug
						end,
						cond = cmake.is_cmake_project,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeDebug")
								end
							end
						end,
					},
					{
						function()
							return icons.ui.Run
						end,
						cond = cmake.is_cmake_project,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeRun")
								end
							end
						end,
						colors.green,
					},
					{
						function()
							local l_target = cmake.get_launch_target()
							return "[" .. (l_target and l_target or "X") .. "]"
						end,
						cond = cmake.is_cmake_project,
						on_click = function(n, mouse)
							if n == 1 then
								if mouse == "l" then
									vim.cmd("CMakeSelectLaunchTarget")
								end
							end
						end,
					},
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}
