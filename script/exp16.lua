#! /usr/bin/env lua

local function dweibull(a, b, x)
  return (a/b) * (x/b) ^ (a-1) * math.exp(- (x/b) ^ a)
end

-- https://stat.ethz.ch/R-manual/R-patched/library/stats/html/Weibull.html
-- a: scale
-- b: shape
local function pweibull(a, b, x)
  return 1 - math.exp(- (x/b) ^ a)
end

local scale = 2.345
local shape = 5.452

for t = 1, 14 do
  local v = pweibull(scale, shape, t) - pweibull(scale, shape, t - 1)
  print(t, v)
end
