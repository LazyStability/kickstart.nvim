-- Load basic options
print("hello")
require("my-config.options")

-- Load basic keymaps
require("my-config.keymaps")

-- Load autocommands
require("my-config.autocommands")

require("my-config.visual")
require("my-config.tree-sitter")
require("my-config.lazy").finish()
