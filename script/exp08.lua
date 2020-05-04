#! /usr/bin/env lua

local mu = 0
local omega = 0.5

local function f(x)
  local y = math.log(x) - mu

  return 1 / (math.sqrt(2 * math.pi) * omega * x) * math.exp(- y * y / (2 * omega * omega))
end

for x = 0.1, 3.0, 0.1 do
  print(f(x))
end
