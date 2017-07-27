import requests
import json
import os

#-----------------------------------------------------------------
# Use Rocketleaguestats.com API to get individual player's stats
# by the player's Steam ID

def get_player_stats(steam_id, auth):
    url = "https://api.rocketleaguestats.com/v1/player" + \
    "?unique_id=" + steam_id + \
    "&platform_id=" + "1"
    
    headers = {"Authorization":"Bearer " + auth}
    
    response = requests.get(url, headers=headers).json()
    
    #stats = json.loads(response.text)
    
    return response

#-------------------------------------------------------------------
# Add player stats (from get_player_stats()) to "db.txt"

def append_record(record):
    with open("../data/db.txt", "a") as f:
        json.dump(record, f)
        f.write(os.linesep)