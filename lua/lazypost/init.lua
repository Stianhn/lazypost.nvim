---@class LazypostConfig
---@field cmd string Command to run
---@field width number Window width (0-1 for percentage, >1 for absolute)
---@field height number Window height (0-1 for percentage, >1 for absolute)
---@field border string Border style
---@field title string Window title
---@field cwd string|nil Working directory

local M = {}

---@type LazypostConfig
local defaults = {
  cmd = "lazypost",
  width = 0.9,
  height = 0.9,
  border = "rounded",
  title = " LazyPost ",
  cwd = nil,
}

---@type LazypostConfig
M.config = {}

---@type number|nil
local buf = nil

---@type number|nil
local win = nil

---Calculate window dimensions
---@param size number Size value (0-1 for percentage, >1 for absolute)
---@param max number Maximum size
---@return number
local function calc_size(size, max)
  if size > 1 then
    return math.min(size, max)
  end
  return math.floor(max * size)
end

---Create the floating window
---@return number win Window handle
---@return number buf Buffer handle
local function create_window()
  local width = calc_size(M.config.width, vim.o.columns)
  local height = calc_size(M.config.height, vim.o.lines - 2)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local new_buf = vim.api.nvim_create_buf(false, true)

  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = M.config.border,
    title = M.config.title,
    title_pos = "center",
  }

  local new_win = vim.api.nvim_open_win(new_buf, true, win_opts)

  vim.api.nvim_set_option_value("winhl", "Normal:Normal,FloatBorder:FloatBorder", { win = new_win })

  return new_win, new_buf
end

---Check if the lazypost window is currently open and valid
---@return boolean
local function is_open()
  return win ~= nil and vim.api.nvim_win_is_valid(win)
end

---Setup the plugin with user configuration
---@param opts LazypostConfig|nil
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", defaults, opts or {})
end

---Open LazyPost in a floating terminal
---@param opts LazypostConfig|nil Override config options
function M.open(opts)
  if is_open() then
    vim.api.nvim_set_current_win(win)
    return
  end

  local config = vim.tbl_deep_extend("force", M.config, opts or {})

  win, buf = create_window()

  local term_opts = {}
  if config.cwd then
    term_opts.cwd = config.cwd
  end

  term_opts.on_exit = function()
    if buf and vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
    buf = nil
    win = nil
  end

  vim.fn.termopen(config.cmd, term_opts)
  vim.cmd("startinsert")
end

---Close the LazyPost window
function M.close()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  buf = nil
  win = nil
end

---Toggle LazyPost window
---@param opts LazypostConfig|nil Override config options
function M.toggle(opts)
  if is_open() then
    M.close()
  else
    M.open(opts)
  end
end

---Health check for :checkhealth lazypost
function M.health()
  local health = vim.health or require("health")
  local start = health.start or health.report_start
  local ok = health.ok or health.report_ok
  local warn = health.warn or health.report_warn
  local error_fn = health.error or health.report_error

  start("lazypost.nvim")

  -- Check if lazypost binary exists
  if vim.fn.executable(M.config.cmd) == 1 then
    ok(string.format("'%s' executable found", M.config.cmd))
  else
    error_fn(string.format("'%s' executable not found in PATH", M.config.cmd))
  end

  -- Check for config file
  local config_path = vim.fn.expand("~/.config/lazypost/config.toml")
  if vim.fn.filereadable(config_path) == 1 then
    ok(string.format("Config file found: %s", config_path))
  else
    warn(string.format("Config file not found: %s", config_path))
  end
end

-- Initialize with defaults
M.config = vim.tbl_deep_extend("force", {}, defaults)

return M
