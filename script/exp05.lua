#! /usr/bin/env lua

local function read_data(filename)
  local handle = assert(io.open(filename))

  local i = 0
  local result = {}
  for line in handle:lines() do
    local v = assert(line:match "^%d+\t([%d%.]+)$")
    local v = assert(tonumber(v))
    result[i] = v
    i = i + 1
  end

  return result
end

local data60 = read_data "punch04-60.txt"
local data80 = read_data "punch04-80.txt"

local function f(N, I, r0, r20, gamma, step)
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

  local r = r20
  for a = 21, 80 do
    for b = step, 1, step do
      local dR_dt = gamma * I
      local dI_dt = dR_dt * (r * (1 - (I + R) / N) - 1)
      I = I + dI_dt * step
      R = R + dR_dt * step
    end
    result[a] = I
  end

  return result
end

--[[
N
    100,000
  1,000,000
 10,000,000
100,000,000
]]

f(10000000, 1, 2.5, 2.5 * 0.2, 0.2084, 1 / 16376)
-- f(10000000, 1, 2.5, 2.5 * 0.2, 0.2084, 1 / 16376)

