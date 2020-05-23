#! /usr/bin/env lua

local function p(t, v)
  print(t, v)
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


local gamma = 0.208460960385849
local function I(t, R0, R)
  if t >= 0 then
    if t <= 20 then
      return math.exp(gamma * (R0 - 1) * t)
    else
      return 520 * math.exp(gamma * (R - 1) * (t - 20))
    end
  else
    return 0
  end
end

local data = {}

for t = 0, 80 do
  local v = I(t, 2.5, 0.5)
  data[t] = v
end

for t = 1, 80 do
  local v = data[t]
  local sum = 0
  for tau = 1, math.min(t - 1, 28) do
    local u = data[t - tau]
    local g = generation[tau]
    sum = sum + u * g
  end
  local r = v / sum
  p(t, r)
end
