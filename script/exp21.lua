#! /usr/bin/env lua

local function p(t, v)
  print(t, v)
end

local function pweibull(a, b, x)
  return 1 - math.exp(- (x/b) ^ a)
end

local function r(t)
  return 2.5
end

local generation = {}
local scale = 2.345
local shape = 5.452

for t = 1, 28 do
  local v = pweibull(scale, shape, t) - pweibull(scale, shape, t - 1)
  generation[t] = v
end

local data = { [0] = 1 }

p(0, data[0])
for t = 1, 80 do
  local v = 0
  for tau = 1, math.min(t, 28) do
    v = v + data[t - tau] * generation[tau]
  end
  local x = r(t) * v
  data[t] = x
  p(t, x)
end
