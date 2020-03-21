#! /usr/bin/env lua

local function process_header(filename, line)
  if line == "Age,Persons" then
    return "Diamond Princess"
  else
    return assert(filename:match "([^/]+)%-2019%.csv")
  end
end

local function process_data(line)
  local range, m, n = line:match "^([^,]+),(%d+),(%d+)$"
  if range then
    m = m + n
  else
    range, m = assert(line:match "^([^,]+),(%d+)")
    m = tonumber(m)
  end
  if range == "100+" then
    return m, 100
  end
  local a, b = assert(range:match "^(%d+)%-(%d+)$")
  return m, tonumber(a), tonumber(b)
end

local function read_csv(filename)
  local country
  local total = 0;

  -- 0-9, 10-19, ..., 80-89, 90-99, 100-
  -- 0,   1,     ..., 8,     9,     10
  local data = {}
  for i = 0, 10 do
    data[i] = 0
  end
  local total = 0

  for line in io.lines(filename) do
    line = line:gsub("\r$", "")
    if not country then
      country = process_header(filename, line)
    else
      local m, a, b = process_data(line)
      local i = math.floor(a / 10)
      data[i] = data[i] + m
      total = total + m
    end
  end

  local ratio = {}
  for i = 0, 10 do
    ratio[i] = data[i] / total
  end
  return country, ratio
end

local countries = {}
local dataset = {}

for i = 1, #arg do
  local country, ratio = read_csv(arg[i])
  countries[i] = country
  dataset[i] = ratio
end

io.write "Age"
for i = 1, #countries do
  io.write("\t", countries[i])
end
io.write "\n"

for i = 0, 10 do
  io.write(i * 10)
  if i < 10 then
    io.write("-", i * 10 + 9)
  else
    io.write "+"
  end
  for j = 1, #dataset do
    io.write("\t", dataset[j][i])
  end
  io.write "\n"
end
