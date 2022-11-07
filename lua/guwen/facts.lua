local M = {}

M.fs = {
  root = nil,
  join = function(...)
    return table.concat({ ... }, "/")
  end,
  ["楚辞"] = nil,
  ["唐诗三百首"] = nil,
  ["宋词三百首"] = nil,
  ["古文观止"] = nil,
  ["论语"] = nil,
  ["诗经"] = nil,
}

M.ns = nil

return M
