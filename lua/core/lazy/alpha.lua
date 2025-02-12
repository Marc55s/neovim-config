-- lazy.nvim
return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    lazy = false,
    opts = {
        dashboard = {
            sections = {
                { section = "header" },
                { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                { section = "startup" },
            },
            preset = {
                header = {
                        [[                                                        
        ████ ██████           █████      ██                     
       ███████████             █████                             
       █████████ ███████████████████ ███   ███████████   
      █████████  ███    █████████████ █████ ██████████████   
     █████████ ██████████ █████████ █████ █████ ████ █████   
   ███████████ ███    ███ █████████ █████ █████ ████ █████  
  ██████  █████████████████████ ████ █████ █████ ████ ██████ 
                                                                           ]]     
                },
            },
        },
        keys = {
            { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
        },
    }
}
