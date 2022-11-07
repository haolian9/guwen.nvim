local api = vim.api
local uv = vim.loop
local facts = require("guwen.facts")

local function resolve_root()
  -- thanks to bfredl for this solution: https://github.com/neovim/neovim/issues/20340#issuecomment-1257142131
  local source = debug.getinfo(1, "S").source
  assert(vim.startswith(source, "@") and vim.endswith(source, "setup.lua"), "failed to resolve the root dir of guwen.nvim")
  return vim.fn.fnamemodify(string.sub(source, 2), ":h:h:h")
end

---@param opts table @{NormalFloat, FloatBorder}
-- * table.NormalFloat|FloatBorder: table, see api.nvim_set_hl
return function(opts)
  opts = opts or {}

  do
    facts.fs.root = resolve_root()

    local function subdir(...)
      local parts = { ... }
      table.insert(parts, 1, facts.fs.root)
      return table.concat(parts, "/")
    end

    facts.fs["楚辞"] = subdir("vendor/chinese-poetry/chuci/chuci.json")
    facts.fs["唐诗三百首"] = subdir("vendor/chinese-poetry/mengxue/tangshisanbaishou.json")
    facts.fs["宋词三百首"] = subdir("vendor/chinese-poetry/ci/宋词三百首.json")
    facts.fs["古文观止"] = subdir("vendor/chinese-poetry/mengxue/guwenguanzhi.json")
    facts.fs["论语"] = subdir("vendor/chinese-poetry/lunyu/lunyu.json")
    facts.fs["诗经"] = subdir("vendor/chinese-poetry/shijing/shijing.json")
  end

  do
    local ns = api.nvim_create_namespace("古文")
    api.nvim_set_hl(ns, "NormalFloat", opts.NormalFloat or { ctermfg = 8 })
    api.nvim_set_hl(ns, "FloatBorder", opts.FloatBorder or { ctermfg = 240 })

    facts.ns = ns
  end

  math.randomseed(uv.hrtime())
end
