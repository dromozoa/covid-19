#! /usr/bin/env lua

local unpack = table.unpack or unpack

local function read_data(filename, i)
  local data = {}
  for line in io.lines(filename) do
    local v = assert(tonumber(line:match "([^\t]+)$"))
    data[i] = v
    i = i + 1
  end
  return data
end

local source_filename = "punch04-80.txt"
local result_filename = "punch04-02-80.txt"

local source_filename = "punch04-60.txt"
local result_filename = "punch04-02-60.txt"

local I = read_data(source_filename, 0)
local J = read_data(result_filename, 5)

--[[
  I(t)を感染日のデータを
  J(t)を報告日のデータとする

  J(t)はI(t-6)以前から影響を受けるとわかっている。
  おそらく、I(t-5)からも影響をうけるがほぼ0に思われる。

    u_p = 5
    u_q = 25

  J(t) = A_{u_p} I(t-u_p) + A_{u_p+1} I(t-(u_p+1)) + ... + A_{u_q} I(t-u_q)

  という式で調べる。J(t)の定義域は5から80。

  行列としては
    X A = B
  になる。


]]

local u_p = 6
local u_q = 26
local u_n = u_q - u_p + 1

local t_p = 26
local t_q = 70
local t_n = t_q - t_p + 1

local X = {}
local B = {}
local j = 0
for t = t_p, t_q do
  local R = {}
  local i = 0
  for u = u_p, u_q do
    i = i + 1
    R[i] = I[t - u] or 0
  end

  j = j + 1
  X[j] = R
  B[j] = J[t]
end

io.write "X : matrix("
for j = 1, t_n do
  if j > 1 then
    io.write ",\n"
  end
  io.write "["
  for i = 1, u_n do
    if i > 1 then
      io.write ","
    end
    io.write(("%.17g"):format(X[j][i]))
  end
  io.write "]"
end
io.write ");\n"

io.write "B : matrix("
for j = 1, t_n do
  if j > 1 then
    io.write ",\n"
  end
  io.write(("[%.17g]"):format(B[j]))
end
io.write ");\n"

local function get(X, i, j)
  return assert(X[j][i])
end

local function transpose(X, i, j)
  return assert(X[i][j])
end

local XT_X = {}
local XT_B = {}
for j = 1, u_n do
  XT_X[j] = {}
  for i = 1, u_n do
    local v = 0
    for c = 1, t_n do
      v = v + transpose(X, c, j) * get(X, i, c)
    end
    XT_X[j][i] = v
  end
  local v = 0
  for c = 1, t_n do
    v = v + transpose(X, c, j) * B[c]
  end
  XT_B[j] = v
end

io.write "XT_X : matrix("
for j = 1, u_n do
  if j > 1 then
    io.write ",\n"
  end
  io.write "["
  for i = 1, u_n do
    if i > 1 then
      io.write ","
    end
    io.write(("%.17g"):format(XT_X[j][i]))
  end
  io.write "]"
end
io.write ");\n"

io.write "XT_B : matrix("
for j = 1, u_n do
  if j > 1 then
    io.write ",\n"
  end
  io.write(("[%.17g]"):format(XT_B[j]))
end
io.write ");\n"


