local outputPath = 'C:\\OutputSVG\\'
local potraceEXE = 'C:\\potrace.exe'

function bdf2Svg(file)
		local f = io.open(file)
		local charList = file:read('*all')
		for char in charList:gmatch('STARTCHAR (.-)ENDCHAR') do
				local s = split(char,'\n')
				local o = io.open(outputPath..s[1]..'.pbm', 'w+')
				local maxX,maxY = s[5]:match('(%d+) (%d+)')
				o:write('P1\n', maxX, ' ', maxY, '\n')
				for i = 7,(7+maxY-1) do
					o:write(binaryConvert(s[i], maxX), '\n')
				end
				o:close()
				os.execute('"'..potraceEXE..'" "'..outputPath..s[1]..'.pbm" -z white -n -d 1 -a 0 -t 0 -s -o "'..outputPath..s[1]..'.svg"')
		end
		f:close()
end

--https://stackoverflow.com/a/7615129
function split(inputstr, sep)
		if sep == nil then
				sep = "%s"
		end
		local t={} ; i=1
		for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
				t[i] = str
				i = i + 1
		end
		return t
end

function binaryConvert(hex, max)
		local total = string.len(hex)*4
		local result, num = {}, tonumber(hex, 16)
		if num == 0 then
				for i = 1,total do
						table.insert(result, 0)
				end
		else
				while num > 0 do
						table.insert(result, 1, num % 2)
						num = math.floor(num / 2)
				end
				if #result < total then
						for i = #result+1,total do
								table.insert(result, 1, 0)
						end
				end
		end
		return table.concat(result,' ', 1, max)
end	