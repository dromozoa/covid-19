#! /usr/bin/env lua

local calendar = require "dromozoa.calendar"

local N = 10000000
local gamma = 0.208460960385849

local JDN = calendar.date_to_jdn(2020, 4, 7)
local T = 30

local is_imported = true

local function p(t, v)
  local w = v
  local u = v - 1
  if u < 0 then
    u = 0
  else
    v = 1
  end

  local year, month, day = calendar.jdn_to_date(JDN - T + t)
  local date = ("%d-%02d-%02d"):format(year, month, day)

  -- print(t, date, v, u, w)

  io.write(([[
%d,%s,%.17g,%.17g,%.17g,%.17g
]]):format(t, date, v, u, w, 0))
end

io.write "t,onset,imported,domestic,total,imported_delay\n"

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
  end
end

-- f(10000000, 1, 2.5, 2.5 * 1, gamma, 1 / 16376)
-- f(10000000, 1, 2.5, 2.5 * 0.8, gamma, 1 / 16376)
f(10000000, 1, 2.5, 2.5 * 0.2, gamma, 1 / 16376)
