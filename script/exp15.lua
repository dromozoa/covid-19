#! /usr/bin/env lua

local xml = require "dromozoa.xml"
local calendar = require "dromozoa.calendar"

local unpack = table.unpack or unpack

local JDN = calendar.date_to_jdn(2020, 4, 7)
local T = 20
local is_imported = true

local counter  = 0

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

io.write "t,onset,imported,domestic,total,imported_delay\n"

for t = 0, 80 do
  local v = I(t, 2.5, 0.5)
  p(t, v)
end

-- path(svg:query "#g2281 > path" :attr "d")
-- path(svg:query "#g2323 > path" :attr "d")
-- scale(svg:query "#g2231 > path" :attr "d")
-- 報告日は5日めから
-- path(svg:query "#g2365 > path" :attr "d")
-- path(svg:query "#g2407 > path" :attr "d")
