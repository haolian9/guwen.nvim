---@class guwen.Source
---@field title string
---@field metadata string[]
---@field contents string[]
---@field notes string[]
---@field width number

local M = {}

local api = vim.api
local sources = require("guwen.sources")
local render = require("guwen.render")

local last_win

local function entrypoint(src_name)
  return function()
    if last_win ~= nil and api.nvim_win_is_valid(last_win) then api.nvim_win_close(last_win, true) end
    local host_win_id = api.nvim_get_current_win()
    local win_width = api.nvim_win_get_width(host_win_id)
    local win_height = api.nvim_win_get_height(host_win_id)
    last_win = render(win_width, win_height, sources[src_name](win_width))
  end
end

M["唐诗一首"] = entrypoint("唐诗三百首")
M["宋词一首"] = entrypoint("宋词三百首")
M["楚辞一篇"] = entrypoint("楚辞")
M["古文一篇"] = entrypoint("古文观止")
M["诗经一篇"] = entrypoint("诗经")
M["论语一篇"] = entrypoint("论语")

M._completion = (function()
  local candidates = {}
  for key, _ in pairs(M) do
    if key ~= "_completion" then table.insert(candidates, key) end
  end
  return candidates
end)()

return M
