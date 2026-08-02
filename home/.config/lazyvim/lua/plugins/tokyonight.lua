return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  -- Garante que o LazyVim mescle as configurações de cores e destaques corretamente
  opts_extend = { "opts.on_colors", "opts.on_highlights" },
  opts = {
    style = "night",
    transparent = false,
    styles = {
      sidebars = "dark",
      floats = "dark",
    },
    -- Força toda a paleta de fundo para o seu tom quase preto original
    on_colors = function(colors)
      colors.bg = "#101414"         -- Fundo do editor principal
      colors.bg_sidebar = "#101414" -- Fundo do explorer (Neo-tree)
      colors.bg_dark = "#101414"    -- Fundo secundário
      colors.bg_float = "#101414"   -- Fundo das janelas flutuantes
    end,

    -- Configura as bordas finas de separação (com letras maiúsculas corretas)
    on_highlights = function(hl, c)
      -- 1. Linha fina divisória das janelas abertas lado a lado (splits)
      hl.WinSeparator = {
        fg = "#565f89", -- Cor cinza de destaque para a borda
        bold = false,
      }

      -- 2. Linhas finas contornando os popups e janelas flutuantes
      hl.FloatBorder = {
        fg = "#565f89",
      }
      hl.LspInfoBorder = {
        fg = "#565f89",
      }
    end,
  },
}
