# Creators’ economy: a study of content creation and monetisation strategies on YouTube and Twitch

This repository gathers all the scripts created for the first chapter of my doctoral dissertation. The latter was submitted to the [Review of Industrial Economics](https://journals.openedition.org/rei/). The scripts are grouped per analytical purpose: 
1) to collect creators' contact info; 
2) to clean the creators' response to our survey; 
3) to compute a hierarchical clustering on principal components in order to gather respondents with similar production and monetisation strategies; 
4) to estimate the adoption factors for each creative production model.

## Paper abstract
This article examines the organisation of French online content creation through an analysis of the business models of creators active either on YouTube or Twitch. Our findings highlight similarities with the traditional creative endeavour, as there are disparities in the audience and revenue among content creators. Through a Hierarchical Clustering on Principal Components (HCPC), we identify three distinct sets of production and monetization strategies (also referred to as creative models): amateur production, commercial endeavour in an indirect partnership with brands and advertisers, and commercial endeavour in a direct partnership with brands. Moreover, we find that the adoption of a creative model is linked with a creator’s choice of preferred platform, his videos’ genre and his audience size. These characteristics are key eligibility criteria in a platform’s monetisation policy. Our results shed additional light on the dependence relation between content creators and platforms.

## Requiered libraries
 **Python**: Pandas; numpy.  
 **R**: dplyr; FactoMineR; nnet; lmtest; fastDummies; psych; stargazer.  

## Presentation of the files
### 1. To collect YouTube creators' contact info.
In this paper, we study the production and monetisation strategies of content creators active on Twitch and YouTube. Despite offering similar services to its users, the two platforms do not provide similar access to data through its API. Information collection was done manually on Twitch, while we could automate the process with YouTube's API. 

For **Twitch**, we gathered information on active French-speaking creators on Twitch through a manual collection. Content creators on Twitch can specify the language of their broadcasts with specific tags under the livestream and VOD, by indicating it in the stream settings (‘stream manager’). To identify French-speaking producers, we looked at the “French” tag section. Multiple times through the day in March 2022, we went to the online creators' channels in this section and retrieved contact details from the “Bio” section. 

For **YouTube**, we created a script in Python to collect data in the “Trending” section of the website. This section lists videos that YouTube certifies as “trending” among the viewers from the same country. A variety of criteria are taken into account, such as the number of views and the publication date. This folder contains the script to retrieve emails from YouTube trending videos' descriptions. Through YouTube's API, we request the list of trending videos in France for each genre and their description. Then, we parse the description to find email addresses with a regular expression. We made additional API requests to identify which publishing channel is located in France. 

### 2. To clean the creators' response to our survey AND 3. to compute a hierarchical clustering on principal components (HCPC).
The folder "*2_Stastical_summary_and_HCPC*" contains the scripts in Python (jupyter notebooks) and R used for data cleaning, deep dive stastical summary and HCPC. We do not provide the initial dataset containing the survey responses.

### 4. To estimate the adoption factors for each creative production model.
The folder "*3_Econometrics*" contains two scripts. The first one, written in Python, helps the users to select and construct the variables for the econometric regression (Multinomial Logistic Regression). The second file, written in R, runs different econometric regressions for different scenario (reference creative model and reference control variables).
