local M = {}

function M.check()
  local lazypost = require("lazypost")
  lazypost.health()
end

return M
