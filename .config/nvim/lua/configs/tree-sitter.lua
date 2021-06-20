-- Tree Sitter: https://github.com/nvim-treesitter/nvim-treesitter

require'nvim-treesitter.configs'.setup {

  ensure_installed = {
    'bash', 'c', 'comment', 'cpp', 'css', 'dockerfile', 'fish', 'go',
    'gomod', 'graphql', 'html', 'java', 'javascript', 'json', 'lua',
    'python', 'regex', 'rst', 'rust', 'swift', 'toml', 'typescript', 'yaml'
  },

  highlight = {
    enable = true
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  refactor = {
    smart_rename = {enable = true, keymaps = {smart_rename = "grr"}},
    highlight_definitions = {enable = true}
    -- highlight_current_scope = { enable = true }
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['iF'] = {
          python = '(function_definition) @function',
          cpp = '(function_definition) @function',
          c = '(function_definition) @function',
          java = '(method_declaration) @function'
        },
        -- or you use the queries from supported languages with textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['aC'] = '@class.outer',
        ['iC'] = '@class.inner',
        ['ac'] = '@conditional.outer',
        ['ic'] = '@conditional.inner',
        ['ae'] = '@block.outer',
        ['ie'] = '@block.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['is'] = '@statement.inner',
        ['as'] = '@statement.outer',
        ['ad'] = '@comment.outer',
        ['am'] = '@call.outer',
        ['im'] = '@call.inner'
      }
    }
  }
}

require "nvim-treesitter.configs".setup {
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
