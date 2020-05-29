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

local function f(N, I, r0, r1, gamma, step)
  local R = 0

  local result = { [0] = I }

  p(0, 0)

  local r = r0
  for a = 1, 30 do
    local S0 = N - I - R
    local d
    for b = step, 1, step do
      local dR_dt = gamma * I
      local dI_dt = dR_dt * (r * (1 - (I + R) / N) - 1)
      local dS_dt = -(dR_dt + dI_dt)
      I = I + dI_dt * step
      R = R + dR_dt * step
      d = -dS_dt
      -- print(a + b, -dS_dt)
    end
    local S1 = N - I - R
    -- local dS = S1 - S0
    p(a, d)
    result[a] = d
  end

  local r = r1
  for a = 31, 50 do
    local S0 = N - I - R
    local d
    local x = 0
    for b = step, 1, step do
      local dR_dt = gamma * I
      local dI_dt = dR_dt * (r * (1 - (I + R) / N) - 1)
      local dS_dt = -(dR_dt + dI_dt)
      I = I + dI_dt * step
      R = R + dR_dt * step
      d = -dS_dt

      if a == 31 then
        x = x + 1
        if x % 256 == 0 then
          -- print(a + b - 1, d)
        end
      end

      -- print(a + b, -dS_dt)
    end
    local S1 = N - I - R
    -- local dS = S1 - S0
    p(a, d)
    result[a] = d
  end

  return result
end

local data = f(10000000, 1, 2.5, 2.5 * 0.2, gamma, 1 / 16376)

-- os.exit()

for t = 1, 50 do
  local v = data[t]
  local sum = 0
  for tau = 1, math.min(t - 1, 28) do
    local u = data[t - tau]
    local g = generation[tau]
    sum = sum + u * g
  end
  local r = v / sum
  print(t, r)
end
