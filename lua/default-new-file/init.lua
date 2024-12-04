local M = {}

local default_config = {
  pattern = { '*' },
  template_path = vim.fn.stdpath('data') .. '/default-new-file.nvim',
}
local global_config = {}

local function read_file(file_path)
  local file = io.open(file_path, 'r')
  if not file then
    vim.notify('template not found: ' .. file_path, vim.log.levels.WARN)
    return nil
  end
  local content = file:read('*a')
  file:close()
  return content
end

local function get_template_by_ft(filetype)
  return read_file(global_config.template_path .. '/' .. filetype)
end

local function file_exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

local function insert_template()
  local filetype = vim.bo.filetype -- current buffer file type
  local template = get_template_by_ft(filetype)
  if template == nil then
    return
  end

  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  if vim.api.nvim_get_option_value('modifiable', { buf = 0 }) then
    vim.api.nvim_buf_set_lines(0, row, -1, false, vim.split(template, '\n'))
  end
end

local function setup_autocmd()
  vim.api.nvim_create_autocmd('BufNewFile', {
    pattern = global_config.pattern,
    callback = function(args)
      if file_exists(args.file) then
        return
      end

      insert_template()
    end,
  })
end

-- usage: DefaultNewFile {filetype}
vim.api.nvim_create_user_command('DefaultNewFile', function(opts)
  local args = vim.split(opts.args, ' ', { trimempty = true })
  local filetype = args[1]
  local path = global_config.template_path .. '/' .. filetype
  vim.cmd(':e ' .. path)
  vim.cmd(':set filetype=' .. filetype)
end, { nargs = 1 })

function M.setup(opts)
  global_config = vim.tbl_deep_extend('force', default_config, opts or {})
  setup_autocmd()
  vim.fn.mkdir(global_config.template_path, 'p')
end

M.insert_template = insert_template

return M
