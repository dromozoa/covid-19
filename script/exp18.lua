#! /usr/bin/env lua

local function p(t, v)
  -- print(t, v)
end

local function pweibull(a, b, x)
  return 1 - math.exp(- (x/b) ^ a)
end

local generation = {}
local scale = 2.345
local shape = 5.452

for t = 1, 28 do
  local v = pweibull(scale, shape, t) - pweibull(scale, shape, t - 1)
  generation[t] = v
end

local data = {}
local t = 0
for line in io.lines() do
  local v = assert(tonumber(line:match "\t([^\t]+)$"))
  data[t] = v
  t = t + 1
end

for t = 1, 80 do
  local v = data[t]
  local sum = 0
  for tau = 1, math.min(t, 28) do -- ????
    local u = data[t - tau]
    local g = generation[tau]
    sum = sum + u * g
  end
  local r = v / sum
  print(t, r)
end
