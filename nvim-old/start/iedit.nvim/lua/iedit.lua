local M = {}
local P = vim.pretty_print

---@alias Iedit.Mode 'n'|'i'|'x'

---@class Iedit.Mapping
---@field [1] Iedit.Mode
---@field [2] string
---@field [3] function

---@class Iedit.Config
---@field default_source 'last-search'
---@field mapping Iedit.Mapping[]
local config = nil
---@param opts Iedit.Config
function M.setup(opts)
    config = vim.tbl_deep_extend('force', config, opts)
    vim.api.nvim_set_hl(0, 'IeditMatch', {default = true, link = 'IncSearch'})

    local grp = vim.api.nvim_create_augroup('IeditGlobal', {})
    vim.api.nvim_create_autocmd('BufDelete', {
        group = grp,
        callback = function(event)
            if _G.iedit_state then _G.iedit_state[event.buf] = nil end
        end
    })
end

---@return Iedit.State
local function get_buf_state()
    return vim.tbl_get(_G, 'iedit_state', vim.api.nvim_get_current_buf())
end
---@param state Iedit.State
local function set_buf_state(state)
    if not _G.iedit_state then _G.iedit_state = {} end
    _G.iedit_state[vim.api.nvim_get_current_buf()] = state
end

--- State of an active iedit buf session.
--- @class Iedit.State
--- @field private pat string
--- @field private ns number
--- @field private keymap_backup table
local State = {pat = nil, ns = nil}

function State.new(init) return vim.tbl_deep_extend('force', State, init or {}) end

function State.start(self)
    if get_buf_state() then
        vim.api.nvim_err_writeln('iedit session already active.')
        return
    end

    set_buf_state(self)
    self.ns = vim.api.nvim_create_namespace('iedit')

    local old_pos = vim.fn.getcurpos()
    table.remove(old_pos, 1)

    vim.fn.cursor(1, 1)
    local match_begin = vim.fn.searchpos(self.pat, 'Wc')
    local matchcount = 0
    while match_begin[1] ~= 0 do
        local match_end = vim.fn.searchpos(self.pat, 'We')
        self:add_match(match_begin, match_end)

        matchcount = matchcount + 1
        match_begin = vim.fn.searchpos(self.pat, 'W')
    end

    vim.fn.cursor(old_pos)

    if matchcount == 0 then self:stop() end

    self:init_mappings()

    print('iedit: ' .. matchcount .. ' matches')
end
function State.stop(self)
    self:fini_mappings()
    set_buf_state(nil)
    vim.api.nvim_buf_clear_namespace(0, self.ns, 0, -1)
end
function State.add_match(self, m_begin, m_end)
    vim.api.nvim_buf_set_extmark(0, self.ns, m_begin[1] - 1, m_begin[2] - 1, {
        end_row = m_end[1] - 1, --
        end_col = m_end[2], --
        hl_group = 'IeditMatch'
        -- TODO: make this higher priority than hlsearch
        -- Not possible yet: https://github.com/neovim/neovim/issues/18756
    })
end

local QueryKeymap = {
    cache = nil,
    clear_cache = function(self) self.cache = {buf = {}, global = {}} end,

    -- Returns result in the same 'maparg()-like' format as nvim.
    query_raw = function(self, mode, lhs, buffer)
        if not self.cache.buf[mode] then
            self.cache.buf[mode] = {}
            local maps = vim.api.nvim_buf_get_keymap(0, mode)
            for _, m in ipairs(maps) do
                self.cache.buf[mode][m.lhs] = m
            end
        end
        local found = self.cache.buf[mode][lhs]
        if buffer or found then return found end

        if not self.cache.global[mode] then
            self.cache.global[mode] = {}
            local maps = vim.api.nvim_get_keymap(mode)
            for _, m in ipairs(maps) do
                self.cache.global[mode][m.lhs] = m
            end
        end
        return self.cache.global[mode][lhs]
    end,

    -- Returns result in a table that can be unpack()-ed into vim.keymap.set()
    query = function(self, mode, lhs, query)
        local map = self:query_raw(mode, lhs, query.buffer)
        if map then
            if map.script == 1 then error('<script> unimplemented') end

            local rhs
            if map.rhs then
                rhs = string.gsub(map.rhs, '<SID>', '<SNR>' .. map.sid .. '_')
            else
                rhs = map.callback
            end

            return {
                mode, lhs, rhs, {
                    remap = (map.noremap == 0) or nil,
                    buffer = (map.buffer ~= 0 and map.buffer) or nil,
                    expr = (map.expr == 1) or nil,
                    nowait = (map.nowait == 1) or nil,
                    silent = (map.silent == 1) or nil
                }
            }
        end
        return nil
    end
}
QueryKeymap:clear_cache()
M.Q = QueryKeymap

---@param mappings Iedit.Mapping[]
---@param query? {buffer: boolean}
---@return any[][] # tables that can be unpacked into keymap.set() args.
local function get_current_mappings(mappings, query)
    local ret = {}

    QueryKeymap:clear_cache()
    for _, mapping in ipairs(mappings) do
        local mode, lhs, _ = unpack(mapping)

        lhs = vim.api.nvim_replace_termcodes(lhs, true, false, true)
        if ret[mode] == nil then ret[mode] = {} end

        ret[mode][lhs] = QueryKeymap:query(mode, lhs, query) or false
    end
    return ret
end

function State.init_mappings(self)
    self.keymap_backup = get_current_mappings(config.mapping, {buffer = true})

    for _, map_ in ipairs(config.mapping) do
        local mode, lhs, cb = unpack(map_)
        lhs = vim.api.nvim_replace_termcodes(lhs, true, false, true)

        local bak = self.keymap_backup[mode][lhs]
        local fallback
        local map = {
            mode, lhs, function() cb(fallback) end,
            {buffer = true, replace_keycodes = false}
        }

        if bak then
            fallback = function()
                local _, _, rhs, opts = unpack(bak)
                if type(rhs) == 'function' and not opts.expr and not opts.silent then
                    bak.callback()
                else
                    vim.keymap.set(unpack(bak))
                    vim.api.nvim_feedkeys(lhs, 't', false)
                    vim.keymap.set(unpack(map))
                end
            end
        else
            fallback = function() end
        end

        vim.keymap.set(unpack(map))
    end
end
function State.fini_mappings(self)
    if not self.keymap_backup then return end
    P(self.keymap_backup)
    for mode, maps in pairs(self.keymap_backup) do
        for lhs, map in pairs(maps) do
            if map then
                assert(map[4].buffer, 'we should only be dealing with buffer' ..
                           ' mappings in the first place.')
                vim.keymap.set(unpack(map))
            else
                vim.keymap.del(mode, lhs, {buffer = true})
            end
        end
    end
end

function State.is_cursor_in_match(self)
    local cursor = vim.fn.getcurpos()
    local matches = vim.api.nvim_buf_get_extmarks(0, self.ns,
                                                  {cursor[2], cursor[3] - 1},
                                                  {cursor[2], cursor[3]}, {})
    P(matches)
end

---Begin iedit session in current buffer
---@param opts {source: 'last-search'}
function M.iedit(opts)
    local source = opts.source or config.default_source
    local pat
    if source == 'last-search' then
        pat = vim.fn.getreg('/')
        vim.cmd('nohlsearch')
    else
        error('Invalid source "' .. source .. '"!', 2)
    end

    local state = State.new({pat = pat})
    state:start()
end

function M.stop()
    local state = get_buf_state()
    if not state then return end

    state:stop()
end

function M.is_cursor_in_match()
    local state = get_buf_state()
    if not state then return end

    state:is_cursor_in_match()
end

M.mapping = {}
M.mapping.stop = M.stop
function M.mapping.delete_matches(fallback)
    if M.is_cursor_in_match() then
        M.delete_matches()
    else
        fallback()
    end
end
function M.mapping.change_matches(fallback)
    if M.is_cursor_in_match() then
        M.change_matches()
    else
        fallback()
    end
end
function M.mapping.insert_front(fallback)
    if M.is_cursor_in_match() then
        M.insert_front_matches()
    else
        fallback()
    end
end
function M.mapping.insert_back(fallback)
    if M.is_cursor_in_match() then
        M.insert_back_matches()
    else
        fallback()
    end
end

---@type Iedit.Config
config = {
    default_source = 'last-search',
    mapping = {
        {'n', '<LocalLeader>T', M.mapping.delete_matches}, --
        {'n', '<Leader>ff', M.mapping.delete_matches}, --
        {'n', 'D', M.mapping.delete_matches}, --
        {'n', 'C', M.mapping.change_matches}, --
        {'n', 'I', M.mapping.insert_front}, --
        {'n', 'A', M.mapping.insert_back}, --
        {'n', '<Esc>', M.mapping.stop}
    }
}

setmetatable(M, {__call = function(_, opts) M.iedit(opts) end})
return M
