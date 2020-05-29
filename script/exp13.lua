#! /usr/bin/env lua

-- https://www.stat.go.jp/data/jinsui/new.html
local N = 12596 * 10000
local gamma = 0.208460960385849

local function f(N, I, r, gamma, step, M)
  local R = 0
  local data = {}

  local result = { [0] = I + R }
  for a = 1, M do
    for b = step, 1, step do
      local dR_dt = gamma * I
      local dI_dt = dR_dt * (r * (1 - (I + R) / N) - 1)
      I = I + dI_dt * step
      R = R + dR_dt * step
    end
    result[a] = I + R
  end

  return result
end

-- f(10000000, 1, 2.5, 2.5 * 1, gamma, 1 / 16376)
-- f(10000000, 1, 2.5, 2.5 * 0.8, gamma, 1 / 16376)

local M = 80

local dataset = {}
for R = 0.5, 3.05, 0.1 do
  local result = f(N, 10, R, gamma, 1 / 16376, M)
  dataset[#dataset + 1] = { R, result }
end

io.write "#"
for i = 1, #dataset do
  io.write(("\tR=%3.1f"):format(dataset[i][1]))
end
io.write "\n"

for i = 0, 80 do
  io.write(i)
  for j = 1, #dataset do
    io.write(("\t%.17g"):format(dataset[j][2][i]))
  end
  io.write "\n"
end
