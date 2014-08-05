-- luamidi Testcase
-- Copyright (c)'2014 Florian Fischer^SiENcE
-- 
-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated documentation files
-- (the "Software"), to deal in the Software without restriction,
-- including without limitation the rights to use, copy, modify, merge,
-- publish, distribute, sublicense, and/or sell copies of the Software,
-- and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
-- 
-- Any person wishing to distribute modifications to the Software is
-- asked to send the modifications to the original developer so that
-- they can be incorporated into the canonical version.  This is,
-- however, not a binding provision of this license.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
-- ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
-- CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


-- Commands:
-- 144 - Node ON
-- 128 - Node OFF
-- 176 - change Volume [command, ?, vol (0-100)] 
-- 192 - Program change [command, patch-number]

local midi = require "luamidi"

local device = 0
local outChannel = 0
local out0 = nil
local outputports = midi.getoutportcount()
local inputports = midi.getinportcount()

function love.load()

	print("Midi Output Ports: ", outputports)
	if outputports > 0 then
		table.foreach(midi.enumerateoutports(), print)
		print()

		out0 = midi.openout(device)
		print( 'Play on device: ', midi.getOutPortName(device) )
		
		-- port, note, [vel], [channel]
--		midi.noteOn(0, 60, 50, 1)

		-- note, [vel], [channel]
		out0:noteOn( 60, 50, 1 )

		-- change Volume: command, control (0-127), value (0-127)
		--out0:sendMessage( 176, 7, 100 )

		-- change Program: command, program (0-127)
		--out0:sendMessage( 192, 5 )
	end

	print("Midi Input Ports: ", inputports)
	if inputports > 0 then
		table.foreach(midi.enumerateinports(), print)
		print( 'Receiving on device: ', luamidi.getInPortName(0))
		print()
	end
end

function love.draw()
    love.graphics.print('Hello World!', 400, 300)
end

local a,b,c,d = nil
function love.update(dt)
	if out0 and inputports > 0 then
		-- command, note, velocity, delta-time-to-last-event (just ignore)
		a,b,c,d = midi.getMessage(0)
		
		if a ~= nil then
			if a == 144 then
				print('Note turned ON:	', a, b, c, d)
				out0:noteOn( b, c, outChannel )
			elseif a == 128 then
				print('Note turned OFF:', a, b, c, d)
				out0:noteOff( b, c, outChannel )
			end
		end
	end
end

function love.quit()
	midi.gc()
end
