#! /usr/bin/env lua

local function f(N, I, r0, r1, r2, gamma, step, flag)
  local R = 0

  local result = { [0] = I }

  local r = r0
  for a = 1, 20 do
    for b = step, 1, step do
      local dR_dt = gamma * I
      local dI_dt = dR_dt * (r * (1 - (I + R) / N) - 1)
      I = I + dI_dt * step
      R = R + dR_dt * step
    end
    result[a] = I
  end

  local r = r1
  for a = 21, 27 do
    for b = step, 1, step do
      local dR_dt = gamma * I
      local dI_dt = dR_dt * (r * (1 - (I + R) / N) - 1)
      I = I + dI_dt * step
      R = R + dR_dt * step
    end
    result[a] = I
  end

  local r = r2
  for a = 28, 34 do
    for b = step, 1, step do
      local dR_dt = gamma * I
      local dI_dt = dR_dt * (r * (1 - (I + R) / N) - 1)
      I = I + dI_dt * step
      R = R + dR_dt * step
    end
    result[a] = I
  end

  local d = result[27] - result[34]
  -- print(d)

  if flag then
    for i = 0, 34 do
      print(result[i])
    end
  end

  return d
end

--[[
N
    100,000
  1,000,000
 10,000,000
100,000,000
]]

local A = 1000000
local C = 10000000
local X = 1200 / 354 / 2

for i = 1, 30 do
  local B = math.floor((A + C) / 2)

  local a = f(A, 1, 2.5, 2.5 * 0.6, 2.5 * 0.4, 0.2084, 1 / 16376)
  local b = f(B, 1, 2.5, 2.5 * 0.6, 2.5 * 0.4, 0.2084, 1 / 16376)
  local c = f(C, 1, 2.5, 2.5 * 0.6, 2.5 * 0.4, 0.2084, 1 / 16376)

  print(A, B, C)

  if b < 1.7 then
    C = B
  else
    A = B
  end
end

f(3055543, 1, 2.5, 2.5 * 0.6, 2.5 * 0.4, 0.2084, 1 / 16376, true)
