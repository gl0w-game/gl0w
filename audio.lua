local denver = require 'libs/denver'

-- most of the player code shamelessly stolen from
-- http://timeforbirds.tumblr.com/post/135143824558/obsessed-with-the-tracker-anon-again-how-did-you

local ch1 = denver.get({waveform='triangle', frequency="C0"})
local ch2 = denver.get({waveform='square', frequency="C0"})
ch1:setLooping(true)
ch2:setLooping(true)

local dsamples = {
    love.audio.newSource("assets/samples/kck.wav","static"),
    love.audio.newSource("assets/samples/clp.wav","static"),
    love.audio.newSource("assets/samples/kcp.wav","static"),
    love.audio.newSource("assets/samples/hhc.wav","static"),
    love.audio.newSource("assets/samples/hho.wav","static")
}

local melodies = {
    {
        {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
        {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
        {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
        {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
        {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
        {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
        {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
        {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil}
    },
    {
        {62,62,nil,nil,62,62,nil,nil,nil,nil,62,62,65,65,62,62},
        {72,72,nil,nil,72,72,nil,nil,nil,nil,74,74,nil,nil,72,72},
        {67,67,nil,nil,67,67,nil,nil,nil,nil,65,65,nil,nil,67,67},
        {69,69,69,69,nil,nil,67,67,67,67,72,72,72,72,72,72},
        {62,62,nil,nil,62,62,nil,nil,nil,nil,62,62,65,65,74,74},
        {72,72,nil,nil,69,69,nil,nil,nil,nil,69,69,nil,nil,67,67},
        {70,70,nil,nil,67,67,nil,nil,nil,nil,67,67,nil,nil,65,65},
        {69,69,nil,nil,69,69,72,72,72,72,74,74,74,74,74,74}
    },
    {
        {69,69,65,nil,64,nil,65,65,67,67,nil,nil,69,nil,67,nil},
        {62,62,nil,nil,65,65,nil,nil,64,64,nil,nil,67,65,nil,nil},
        {69,69,65,nil,64,nil,65,65,67,67,nil,nil,69,nil,74,nil},
        {73,73,nil,nil,76,76,nil,nil,73,73,nil,nil,70,70,nil,nil},
        {69,69,65,nil,64,nil,65,65,67,67,nil,nil,69,nil,67,nil},
        {65,65,nil,nil,69,69,nil,nil,67,67,nil,nil,64,64,nil,nil},
        {69,69,65,nil,62,nil,64,64,65,65,nil,nil,69,nil,74,nil},
        {73,73,nil,nil,74,74,nil,nil,73,73,nil,nil,76,76,nil,nil}
    },
    {
        {65,nil,64,nil,62,70,70,nil,69,nil,67,nil,64,69,nil,nil},
        {65,nil,64,nil,62,65,70,nil,65,nil,64,62,67,nil,nil,nil},
        {65,nil,64,nil,62,70,70,nil,69,nil,67,nil,69,nil,nil,nil},
        {70,nil,69,nil,67,nil,nil,70,61,74,nil,76,69,nil,nil,nil},
        {65,nil,64,nil,62,70,70,nil,69,nil,67,nil,69,nil,nil,nil},
        {67,nil,65,64,nil,67,70,nil,65,nil,64,62,67,nil,nil,nil},
        {65,nil,64,nil,62,70,70,nil,69,nil,67,nil,69,nil,nil,nil},
        {74,nil,72,nil,69,nil,nil,74,73,78,nil,76,74,nil,nil,nil}    }    
}

local bassline = {
    {38,nil,38,nil,33,nil,33,nil,38,nil,38,nil,33,nil,33,nil},
    {38,38,nil,nil,33,33,nil,nil,38,38,nil,nil,45,45,nil,nil},
    {43,nil,43,nil,38,nil,38,nil,43,nil,43,nil,46,nil,46,nil},
    {45,45,nil,nil,41,41,nil,nil,33,33,nil,nil,41,41,nil,nil},
    {38,nil,38,nil,33,nil,33,nil,38,nil,38,nil,33,nil,33,nil},
    {38,38,nil,nil,33,33,nil,nil,38,38,nil,nil,45,45,nil,nil},
    {43,nil,43,nil,38,nil,38,nil,43,nil,43,nil,46,nil,46,nil},
    {45,45,nil,nil,41,41,nil,nil,33,33,nil,nil,41,41,nil,nil}    
}

local drums = {
    {1,nil,nil,4,3,nil,nil,nil,1,nil,nil,4,3,nil,5,4},
    {1,nil,4,4,3,5,4,nil,1,4,1,4,3,5,1,4},
    {1,nil,nil,4,3,nil,5,nil,1,nil,nil,4,3,nil,5,4},        
    {1,nil,4,4,3,5,4,nil,1,4,1,4,3,5,1,4},
    {1,nil,nil,4,3,5,nil,5,1,nil,nil,4,3,3,3,3},
    {1,nil,4,4,3,5,4,nil,1,4,1,4,3,5,1,4},
    {1,nil,nil,4,3,nil,nil,nil,1,nil,nil,4,3,nil,5,4},
    {1,nil,4,4,3,5,4,nil,1,4,1,4,3,5,1,4}
}

local posnext = 0
local bar = 1
local sixteenth = 1
local playing = 1
local bpm = 120
local notes1 = bassline
local notes2 = melodies[1]

function setTempo(tempo)
    bpm = tempo
end

function setMelody(melody)
    notes2 = melodies[melody+1]
end

function runAudio(dt)
	if playing == 1 then
		ch1:play()
		ch2:play()
        posnext = posnext+(dt*bpm/60*4)

		if posnext >= 1 then
			posnext = posnext-1
			sixteenth = sixteenth+1
			if sixteenth > 16 then
				bar = bar+1
				sixteenth = 1
			end
			if bar > #notes1 then
				bar = 1
			end

            if notes1[bar][sixteenth] == nil then
                ch1:setVolume( 0 )
            else
                ch1:setVolume( 1 )
                ch1:setPitch( 0.0038*440*math.pow(2,notes1[bar][sixteenth]/12) )
            end

            if notes2[bar][sixteenth] == nil then
                ch2:setVolume( 0 )
            else
                ch2:setVolume( 1 )
                ch2:setPitch( 0.0038*440*math.pow(2,notes2[bar][sixteenth]/12) )
            end

            if not (drums[bar][sixteenth] == nil) then
				dsamples[drums[bar][sixteenth]]:setLooping(false)
				dsamples[drums[bar][sixteenth]]:play()
            end
		end

	else
		ch1:pause()
		ch2:pause()
	end
end