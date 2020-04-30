#! /usr/bin/env lua

local xml = require "dromozoa.xml"

local unpack = table.unpack or unpack

local svg_content = io.read "*a"
local svg = xml.decode(svg_content)

local function parse(d)
  local d = d:gsub(",", " ") .. " "
  local x = {}
  local y
  for item in d:gmatch "%S+" do
    if item:match "^%a$" then
      y = { item }
      x[#x + 1] = y
    else
      y[#y + 1] = assert(tonumber(item))
    end
  end

  local z = {}
  for i = 1, #x do
    local y = x[i]
    local c = y[1]
    if c == "m" then
      assert(#y == 3)
      z[#z + 1] = y
    elseif c == "h" then
      for j = 2, #y do
        z[#z + 1] = { "l", y[j], 0 }
      end
    elseif c == "l" then
      for j = 2, #y, 2 do
        z[#z + 1] = { "l", y[j], y[j + 1] }
      end
    else
      error("unknown command " .. c)
    end
  end

  return z
end

local function round(v)
  return math.floor(v + 0.5)
end

-- ローカル座標の高さ1040が700人に該当する
local L2N = 700 / 312
-- local L2N = 700 / 1040

local function path(d)
  local z = parse(d)

  -- 原点
  local Y = -54.607
  for i = 1, #z do
    local y = z[i]
    local c = y[1]
    if c == "m" then
      assert(i == 1)
      Y = Y + y[3]
      io.write(("%.17g\t%d\t%.17g\n"):format(Y, math.floor(Y * 10 / 6 + 0.5), L2N * Y))
    elseif c == "l" then
      Y = Y + y[3]
      io.write(("%.17g\t%d\t%.17g\n"):format(Y, math.floor(Y * 10 / 6 + 0.5), L2N * Y))
    else
      assert("unknown command " .. c)
    end
  end
end

local function scale(d)
  local z = parse(d)

  -- 原点
  local Y = -546/3
  for i = 1, #z do
    local y = z[i]
    local c = y[1]
    if c == "m" then
      local v = round(y[3] * 10)
      assert(v % 3 == 0, v)
      Y = Y + v / 3
    elseif c == "l" then
      local v = round(y[3] * 10)
      assert(v % 6 == 0)
      Y = Y + v / 3
    else
      assert("unknown command " .. c)
    end
    print(Y, unpack(y))
  end
end

-- path(svg:query "#g2281 > path" :attr "d")
-- path(svg:query "#g2323 > path" :attr "d")
-- scale(svg:query "#g2231 > path" :attr "d")
-- 報告日は5日めから
-- path(svg:query "#g2365 > path" :attr "d")
path(svg:query "#g2407 > path" :attr "d")
