import google_auth_oauthlib.flow
import googleapiclient.discovery
import googleapiclient.errors
import pandas as pd
from datetime import date
import os
import time
import pdb

# DO NOT TOUCH THAT PART OF THE CODE AS IT ALLOWS TO CONNECT TO THE API AND IT WORKS
api_service_name = "youtube"
api_version = "v3"
scopes = ["https://www.googleapis.com/auth/youtube.readonly"]

#sensitive info - login API
#client_secrets_file = the name of the JSON file with credential //  developper_key=API key in console panel
client_secrets_file="code_secret_client_933683395576-v8nhhea76tnsep7up8l1go7bug7fngoj.apps.googleusercontent.com.json"
developer_key="AIzaSyDtwObAVqLgaSYBoLzdBmYzpqjFJONffhU"

flow = google_auth_oauthlib.flow.InstalledAppFlow.from_client_secrets_file(
    client_secrets_file, scopes)
credentials = flow.run_console()
youtube = googleapiclient.discovery.build(
    api_service_name, api_version, developerKey=developer_key)


name_cp=[]
id_cp=[]
name_video=[]
id_video=[]
description=[]
tags=[]
date_published=[]
#Videos().list() method cost only 1 per request
request = youtube.videos().list(
        part="snippet,contentDetails,statistics",
        chart="mostPopular",
        maxResults=50,
        regionCode="FR"
    )
response = request.execute()

for e in range(len(response['items'])): 
    name_cp.append(response['items'][e]['snippet']['channelTitle'])
    id_cp.append(response['items'][e]['snippet']['channelId'] )
    name_video.append(response['items'][e]['snippet']['title'])
    id_video.append(response['items'][e]['id'])
    description.append(response['items'][e]['snippet']['description'])
    try :
        tags.append(response['items'][e]['snippet']['tags'])
    except KeyError : 
        t=[]
        tags.append(t)
    date_published.append(response['items'][e]['snippet']['publishedAt'])

data={'name_cp':name_cp, 'id_cp': id_cp, 'name_video':name_video, 'id_video': id_video, 'description': description, 'tags':tags, 'date_published':date_published}
df_data=pd.DataFrame(data=data)
name='trending_fr.csv'
df_data.to_csv(name, index=False, header=True)
pdb.set_trace()