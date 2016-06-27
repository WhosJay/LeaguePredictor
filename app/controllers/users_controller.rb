require 'net/http'

class UsersController < ApplicationController

  def index
  	@verses = Verse.all
  end

  def currentgame
  	d = Time.now
	  respond_to do |format|
	  		# Finds Summoner's ID, Name, and Picture.
	  		name = "#{params[:name]}"
	  		lower = name.downcase
	  		spaceless = lower.gsub(/\s+/, "")
	  		uri = URI("https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/#{spaceless}?api_key=5a3cb583-47f0-4344-89ab-6c52b15f4082")
				sumresponse = Net::HTTP.get(uri)
				sumresult = JSON.parse(sumresponse)
				sumpic = sumresult[spaceless]['profileIconId']
				@sumname = sumresult[spaceless]['name']
				@sumid = sumresult[spaceless]['id']
				@square = "http://ddragon.leagueoflegends.com/cdn/6.12.1/img/profileicon/#{sumpic}.png"
				# Takes the Summoner's ID and finds the current game they are in.
	  		uritwo = URI("https://na.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/NA1/#{@sumid}?api_key=5a3cb583-47f0-4344-89ab-6c52b15f4082") 
				gameresponse = Net::HTTP.get(uritwo)
				gameresult = JSON.parse(gameresponse)
				team = gameresult['participants']
				@blue = []
				@purple = []
				bwrid = []
				pwrid = []
				@bluepic = []
				@purplepic = []
				@bluechamp = []
				@blueweaks = []
				@bluecounters = []
				@purplechamp = []
				@purpleweaks = []
				@purplecounters = []
				@bluestrongs = []
				@purplestrongs = []
				team.each do |id|
					if id['teamId'] == 100
						teamname = id['summonerName']
						teamsumid = id['summonerId']
						teamsumpic = id['profileIconId']
						teamchamp = id['championId']
						@bluechamp.push(teamchamp)
						@bluepic.push(teamsumpic)
						bwrid.push(teamsumid)
						@blue.push(teamname)
					elsif id['teamId'] == 200
						teamname = id['summonerName']
						teamsumid = id['summonerId']
						teamsumpic = id['profileIconId']
						teamchamp = id['championId']
						@purplechamp.push(teamchamp)
						@purplepic.push(teamsumpic)
						pwrid.push(teamsumid)
						@purple.push(teamname)
					end
				end
	  		@verses = Verse.all
				@bluechamp.each do |id|
					verse = Verse.where(strong_id: id)
					array = []
					verse.each do |weaks|
						weaklings = weaks.weak_id
						array.push(weaklings)
					end
						@blueweaks.push(array)
				end
				@purplechamp.each do |id|
					verse = Verse.where(strong_id: id)
					array = []
					verse.each do |weaks|
						weaklings = weaks.weak_id
						array.push(weaklings)
					end
						@purpleweaks.push(array)
				end
				@blueweaks.each do |id|
					array = []
					id.each do |num|
						@purplechamp.each do |purp|
							if num == purp
								array.push(num)
							end
						end
					end
					@bluecounters.push(array)
				end
				@purpleweaks.each do |id|
					array = []
					id.each do |num|
						@bluechamp.each do |purp|
							if num == purp
								array.push(num)
							end
						end
					end
					@purplecounters.push(array)
				end
				@blueone = @bluecounters[0]
				@bluetwo = @bluecounters[1]
				@bluethree = @bluecounters[2]
				@bluefour = @bluecounters[3]
				@bluefive = @bluecounters[4]
				@purpleone = @purplecounters[0]
				@purpletwo = @purplecounters[1]
				@purplethree = @purplecounters[2]
				@purplefour = @purplecounters[3]
				@purplefive = @purplecounters[4]
				@bsone = @bluechamp[0]
				@bstwo = @bluechamp[1]
				@bsthree = @bluechamp[2]
				@bsfour = @bluechamp[3]
				@bsfive = @bluechamp[4]
				@psone = @purplechamp[0]
				@pstwo = @purplechamp[1]
				@psthree = @purplechamp[2]
				@psfour = @purplechamp[3]
				@psfive = @purplechamp[4]
				# Finds the win rate of each summoner in the current game
				@bbigwr = []
				bwrid.each do |rate|
					urithree = URI("https://na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/#{rate}/recent?api_key=a57bb46a-c181-4f77-b1ce-9ee7e599409a")
					pastresponse = Net::HTTP.get(urithree)
					pastresult = JSON.parse(pastresponse)
					wr = []
					pastwr = pastresult['games']
					pastwr.each do |wins|
						if wins['stats']['win'] == true
							x = 1
							wr.push(x)
						end	
					end
					wrtotal = wr.length
					@bbigwr.push(wrtotal)
				end
				@pbigwr = []
				pwrid.each do |rate|
					urithree = URI("https://na.api.pvp.net/api/lol/na/v1.3/game/by-summoner/#{rate}/recent?api_key=a57bb46a-c181-4f77-b1ce-9ee7e599409a")
					pastresponse = Net::HTTP.get(urithree)
					pastresult = JSON.parse(pastresponse)
					wr = []
					pastwr = pastresult['games']
					pastwr.each do |wins|
						if wins['stats']['win'] == true
							x = 1
							wr.push(x)
						end	
					end
					wrtotal = wr.length
					@pbigwr.push(wrtotal)
				end
				# Find the champions of each summoner in the current game
				@bluechampkey = []
				@bluechampname = []
				@bluechamptitle = []
				@bluechamp.each do |blue|
					urifour = URI("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion/#{blue}?api_key=8d0a098e-d226-4e50-a812-3e4f95809273")
					champresponse = Net::HTTP.get(urifour)
					champresult = JSON.parse(champresponse)
					champkey = champresult['key']
					champname = champresult['name']
					champtitle = champresult['title']
					@bluechampkey.push(champkey)
					@bluechampname.push(champname)
					@bluechamptitle.push(champtitle)
				end
				@purplechampkey = []
				@purplechampname = []
				@purplechamptitle = []
				@purplechamp.each do |purple|
					urifour = URI("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion/#{purple}?api_key=8d0a098e-d226-4e50-a812-3e4f95809273")
					champresponse = Net::HTTP.get(urifour)
					champresult = JSON.parse(champresponse)
					champkey = champresult['key']
					champname = champresult['name']
					champtitle = champresult['title']
					@purplechampkey.push(champkey)
					@purplechampname.push(champname)
					@purplechamptitle.push(champtitle)
				end
      format.js 
	  end
  end

end