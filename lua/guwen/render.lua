local api = vim.api
local facts = require("guwen.facts")


---@param source guwen.Source
local function calc_lines(max_height, source)
  local count = 0
  local function accum(line)
    count = count + math.ceil(api.nvim_strwidth(line) / source.width)
  end

  accum(source.title)
  for _, lines in ipairs({ source.metadata, source.contents, source.notes }) do
    for _, line in ipairs(lines) do
      accum(line)
      if count >= max_height then return max_height end
    end
  end
  return count
end

---@param source guwen.Source
local function render(max_width, max_height, source)
  local bufnr
  local height = 0
  do
    bufnr = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")

    height = calc_lines(max_height, source)

    local start, stop = 0, 0
    local function advance_bounds(n)
      start = stop
      stop = start + n
    end

    advance_bounds(1)
    api.nvim_buf_set_lines(bufnr, start, stop, false, { source.title })

    if #source.metadata > 0 then
      advance_bounds(#source.metadata)
      api.nvim_buf_set_lines(bufnr, start, stop, false, source.metadata)
    end

    advance_bounds(1)
    api.nvim_buf_set_lines(bufnr, start, stop, false, { "" })
    height = height + 1

    advance_bounds(#source.contents)
    api.nvim_buf_set_lines(bufnr, start, stop, false, source.contents)

    if #source.notes > 0 then
      advance_bounds(1)
      api.nvim_buf_set_lines(bufnr, start, stop, false, { "" })
      height = height + 1

      advance_bounds(#source.notes)
      api.nvim_buf_set_lines(bufnr, start, stop, false, source.notes)
    end

    height = math.min(height, max_height)
  end

  local win_id
  do
    local width = source.width

    local col = 0
    if width < max_width then col = math.floor((max_width - width) / 2) end

    local row = 0
    if height < max_height then row = math.floor((max_height - height) / 2) end

    -- stylua: ignore
    win_id = api.nvim_open_win(bufnr, true, {
      relative = "win", style = "minimal", border = "single",
      row = row, col = col, width = width, height = height,
    })
    api.nvim_win_set_option(win_id, "wrap", true)
    api.nvim_win_set_hl_ns(win_id, facts.ns)

    local function close_win()
      api.nvim_win_close(win_id, true)
    end
    api.nvim_buf_set_keymap(bufnr, "n", "q", "", { noremap = true, callback = close_win })
    api.nvim_create_autocmd("WinLeave", { once = true, callback = close_win })
  end

  return win_id
end

return function(...)
  local ok, err = xpcall(render, debug.traceback, ...)
  if not ok then
    vim.notify(vim.inspect({ ... }))
    error(err)
  end
  return err
end
