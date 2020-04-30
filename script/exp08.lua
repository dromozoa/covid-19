#! /usr/bin/env lua

local function read_data(filename, i)
  local data = {}
  for line in io.lines(filename) do
    local v = assert(tonumber(line:match "([^\t]+)$"))
    data[i] = v
    i = i + 1
  end
  return data
end

local source_filename = "punch04-80.txt"
local result_filename = "punch04-02-80.txt"

local source_data = read_data(source_filename, 0)
local result_data = read_data(result_filename, 5)

io.write "M : matrix(\n"

local x = 26
-- local x = 34
local y = 19
local z = 29

for i = x, x + z do
  if i > x then
    io.write ",\n"
  end
  io.write(("[%.17g"):format(result_data[i]))
  for j = i - 6 - y, i - 6 do
    io.write((", %.17g"):format(source_data[j]))
  end
  io.write "]"
end

io.write ")\n"

local vs = { "r" }
local eq = {}
local us = {}
for i = 1, y + 1 do
  local v = "v" .. i
  local u = "u" .. i

  vs[#vs + 1] = v
  us[#us + 1] = u
  eq[#eq + 1] = v .. " * " .. u
end

os.exit()

io.write(([[
lsquares_estimates(
    M,
    [%s],
    r = %s,
    [%s]);
]]):format(
    table.concat(vs, ", "),
    table.concat(eq, " + "),
    table.concat(us, ", ")))

--[[
io.write "], [\n"

for i = 1, y + 1 do
  if i > 1 then
    io.write ", "
  end
  io.write(("x%d"):format(i))
end

-- io.write "]);\n"
io.write "], [\n"

for i = 1, y + 1 do
  if i > 1 then
    io.write ", "
  end
  io.write "0"
end

io.write "]);\n"

]]
