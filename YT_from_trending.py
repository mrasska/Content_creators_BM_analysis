from urllib.error import HTTPError
import google_auth_oauthlib.flow
import googleapiclient.discovery
import googleapiclient.errors
import pandas as pd
from datetime import date
import os
import time
import re
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
dfg=pd.read_csv('cat.csv')
list_id=dfg['cat_id'].to_list()

for b in range(len(list_id)):
    nextPageToken=None
    k=1
    print(list_id[b])
    while k<6:
        print(k)
        request = youtube.videos().list(
                part="snippet,contentDetails,statistics",
                chart="mostPopular",
                pageToken=nextPageToken,
                maxResults=50,
                regionCode="FR", 
                videoCategoryId=list_id[b]
            )
        try : 
            response = request.execute()
        except :
            pass

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
        
        try : 
            nextPageToken=str(response['nextPageToken'])
        except KeyError:
            pass
        k=k+1

def save_raw_csv(name_cp, id_cp, name_video, id_video, description, tags, date_published):
    data={'name_cp':name_cp, 'id_cp': id_cp, 'name_video':name_video, 'id_video': id_video, 'description': description, 'tags':tags, 'date_published':date_published}
    df_data=pd.DataFrame(data=data)
    name='trending_fr.csv'

    if os.path.isfile('./trending_fr.csv')==True :
        df=pd.read_csv(name)
        df.append(df_data)
        df.to_csv(name, index=False, header=True)
    else :
        df_data.to_csv(name, index=False, header=True)
    
    return

def save_contact_csv(name_cp, id_cp, description):
    df_contact=pd.DataFrame(data={'name_cp':name_cp, 'id_cp':id_cp, 'description':description})

    #Transforming the description column into a list in order to execute contains & extractall method
    list_desc=pd.Series(df_contact['description'])
    idx=df_contact['id_cp']
    list_desc.index=idx

    #RE for mail adress = r'[\w.+-]+@[\w-]+\.[\w.-]+'
    #to get all the rows in which the description contains an email adress
    result=list_desc.str.contains(pat=r'[\w.+-]+@[\w-]+\.[\w.-]+', na=False)
    df=list_desc[result]

    #to extract the mail adress / For extractall method - there is a need to change the RE --> pat='([\w.+-]+@[\w-]+\.[\w.-]+)'
    test=list_desc.str.extractall(pat='([\w.+-]+@[\w-]+\.[\w.-]+)')

    #test is a DF
    test.to_csv('mail.csv', index=True, header=True)

    #Cleaning the DB 
    #Loading back the DF bc test header handles errors
    df=pd.read_csv('mail.csv')
    df=df.drop(columns=['match'])
    df=df.drop_duplicates()

    #need to merge with previous database for names of channels
    #df_contact contains raw data - need to retrieve name_cp and to coincide with df ids
    #left df = df  / right df = df_contact
    df_contact=df_contact[['name_cp', 'id_cp']].copy()
    df=df.merge(df_contact, how='inner', on='id_cp')
    df=df.drop_duplicates()

    return df

def get_creators_info(id_cp): 
    channel_country=[]

    for e in range(len(id_cp)):
        creator__id=id_cp[e]

        request_creators=youtube.channels().list(
            part='localizations, snippet, statistics', 
            id=creator__id
        )

        print(creator__id)
        time.sleep(2)
        response_loop = request_creators.execute()
    
        try : 
            channel_country.append(response_loop['items'][0]['snippet']['country'])
        except KeyError : 
            country='N/A'
            channel_country.append(country)
    
    return channel_country

def save_info(df, country): 
    df['country']=country
    df.to_csv('mail.csv', index=True, header=True)
    
    df_fr=df.query('country=="FR"') 
    df_fr.to_csv('mails_fr.csv', index=False, header=True)
    return

df=save_contact_csv(name_cp, id_cp, description)
id_cp=df['id_cp'].to_list()
country=get_creators_info(id_cp)
pdb.set_trace()