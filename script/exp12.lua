#! /usr/bin/env lua

local filename = ...

local data = {}

local i = 0
for line in io.lines(filename) do
  if i > 0 then
    local j, y, m, d = assert(line:match "^(%d+),130001,東京都,,(%d+)%-(%d+)%-(%d+),")
    local datetime = ("%d/%02d/%02d"):format(y, m, d)
    if not datetime_min or datetime_min > datetime then
      datetime_min = datetime
    end
    if not datetime_max or datetime_max < datetime then
      datetime_max = datetime
    end
    data[datetime] = (data[datetime] or 0) + 1
  end
  i = i + 1
end

print(datetime_min)
print(datetime_max)
