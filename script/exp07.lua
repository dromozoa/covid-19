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

io.write "solve(["

local x = 26
for i = x, x + 15 do
  if i > x then
    io.write ",\n"
  end
  local n = 0
  for j = i - 21, i - 6 do
    n = n + 1
    if n > 1 then
      io.write " + "
    end
    io.write(("%.17g * x%d"):format(source_data[j], n))
  end
  io.write((" = %.17g"):format(result_data[i]))
end

io.write "], [\n"

for i = 1, 16 do
  if i > 1 then
    io.write ", "
  end
  io.write(("x%d"):format(i))
end

io.write "]);\n"


-- for i = 6, 32 do
--   print(source_data[i])
-- end

-- for i = 25, 38 do
--   print(result_data[i])
-- end

-- for j = 1, 27 do
--   local items = {}
--   for i = 1, j - 1 do
--     items[i] = 0
--   end
--   for i = j, math.min(j + 13, 27) do
--     items[i] = "a" .. (i - j)
--   end
--   for i = j + 14, 27 do
--     items[i] = 0
--   end
-- 
--   print(table.concat(items, ", "))
-- end

