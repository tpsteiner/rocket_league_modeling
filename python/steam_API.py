import requests
import json
import xmltodict


#----------------------------------------------------------------------
# Get games owned by player, along with total playtime and (limited) last 2 weeks playtime

def get_owned_games(steam_id):
    url = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/" + \
        "?key=" + auth + \
        "&steamid=" + str(steam_id) + \
        "&format=json"
    
    response = requests.get(url)
    
    games_json = remove_white(response.text)
    games_dict = json.loads(games_json)
    games = games_dict["response"]["games"]
    game_count = games_dict["response"]["game_count"]
    
    return [game_count, games]
	
#----------------------------------------------------------------------
def get_friend_list(steam_id):
    url = "http://api.steampowered.com/ISteamUser/GetFriendList/v0001/" + \
        "?key=" + auth + \
        "&steamid=" + str(steam_id) + \
        "&relationship=friend"
    
    response = requests.get(url)
    
    friend_json = remove_white(response.text)
    friends_dict = json.loads(friends_json)
    friends = friends_dict["friendslist"]
    
    return friend_list
	
#----------------------------------------------------------------------
# Get player's public info
# Up to 100 steam ids at a time (comma separated)

def get_player_summaries(steam_ids):
    steam_ids_str = steam_ids[0]
    
    for i in range(len(steam_ids)-1):
        steam_ids_str += "," + str(steam_ids[i])

    url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/" + \
        "?key=" + auth + \
        "&steamids=" + steam_ids_str + \
        "&relationship=friend"
    
    response = requests.get(url)
    
    summaries_json = remove_white(response.text)
    summaries_dict = json.loads(summaries_json)
    summaries = summaries_dict["response"]
    
    return summaries
	

#----------------------------------------------------------------------
def remove_white(s):
    s = s.replace("\n", "")
    s = s.replace("\t", "")
    s = s.replace(" ", "")
    s = s.replace("\\", "")
    
    return s

	
#----------------------------------------------------------------------
# Check if user owns Rocket League

def rl_check(games):
    return '"appid": 252950' in games
	
	
#----------------------------------------------------------------------
# Add player game info to dictionary

def append_games_to_dict(db, steam_id):
    games = get_owned_games(steam_id)
    
    db[steam_id]["game_count"] = games[0]
    db[steam_id]["games"] = games[1]
    
    return db
	
	
#----------------------------------------------------------------------
# Add player friends to dictionary

def append_friends_to_dict(db, steam_id):
    friends = get_friend_list(steam_id)
    
    db[steam_id]["friends"] = friends
    
    return db