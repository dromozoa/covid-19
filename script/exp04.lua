#! /usr/bin/env lua

local I_target = 772 * 700 / 1040

local function f(N, I, R, gamma, step)
  local R0 = 2.5

  for t = 0, 20, step do
    local dR_dt = gamma * I
    local dI_dt = dR_dt * (R0 * (1 - I / N - R / N) - 1)

    I = I + dI_dt * step
    R = R + dR_dt * step
  end

  return I
end

local function search(N, I, gx, gy, step, recursive)
  local n = 4
  local x = {}

  local min_d
  local min_i

  for i = 0, n do
    local g = gx + (gy - gx) * i / n
    local v = f(N, I, 0, g, step)
    local d = math.abs(I_target - v);
    x[i] = {
      g = g;
      I = v;
      d = d;
    }

    if not min_d or min_d > d then
      min_i = i
      min_d = d
    end
  end

  local item = x[min_i]
  -- print(item.g, recursive)

  if recursive > 1 then
    local a = min_i
    local b = min_i

    if a > 1 then
      a = a - 1
    end
    if b < n then
      b = b + 1
    end
    return search(N, I, x[a].g, x[b].g, step, recursive - 1)
  else
    return item.g
  end
end
-- 0.2084 or 0.2085 .. 1/4.8 = 5 / 24

local S = 16376
local step = 1 / S

-- print(search(100000000, 1, 0, 1, 1/24, 32))
print(search(10000000, 1, 0, 1, step, 32))
-- print(search(10000000, 2, 0, 1, 1/24, 32))
