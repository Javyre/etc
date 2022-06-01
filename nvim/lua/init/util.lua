local M = {}

M.Hook = function()
    return {
        fns = {},
        hook = function(self, fn) table.insert(self.fns, fn) end,
        emit = function(self, ...)
            for _, fn in ipairs(self.fns) do fn(...) end
        end
    }
end

return M
