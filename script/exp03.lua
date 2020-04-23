#! /usr/bin/env lua

local xml = require "dromozoa.xml"

local svg_content = io.read "*a"
local svg = xml.decode(svg_content)

local unpack = table.unpack or unpack

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

local function path(d)
  local z = parse(d)

  local Y = 0
  for i = 1, #z do
    local y = z[i]
    local c = y[1]
    if c == "l" then
      Y = Y + y[3]
    end
    print(Y, unpack(y))
  end
end

local function scale(d)
  local z = parse(d)

  local Y = 0
  for i = 1, #z do
    local y = z[i]
    local c = y[1]
    if c == "m" then
      Y = Y + y[3]
    elseif c == "l" then
      Y = Y + y[3]
    else
      assert("unknown command " .. c)
    end
    print(Y, unpack(y))
  end
end

-- path(svg:query "#g2281 > path" :attr "d")
-- path(svg:query "#g2323 > path" :attr "d")
scale(svg:query "#g2231 > path" :attr "d")
