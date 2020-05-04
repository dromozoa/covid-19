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
  for a = 28, 80 do
    for b = step, 1, step do
      local dR_dt = gamma * I
      local dI_dt = dR_dt * (r * (1 - (I + R) / N) - 1)
      I = I + dI_dt * step
      R = R + dR_dt * step
    end
    result[a] = I
  end

  if flag then
    for i = 0, 80 do
      print(result[i])
    end
  end
end

local gamma = 0.208460960385849

-- f(3055544, 1, 2.5, 2.5 * 0.2, 2.5 * 0.2, gamma, 1 / 16376, true)
f(3055544, 1, 2.5, 2.5 * 0.35, 2.5 * 0.35, gamma, 1 / 16376, true)
