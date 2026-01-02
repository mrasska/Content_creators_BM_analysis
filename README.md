# Creators’ economy: a study of content creation and monetisation strategies on YouTube and Twitch
***This ReadMe file is still under construction***

This repository gathers all the scripts created for the first chapter of my doctoral dissertation. The latter was submitted to the [Review of Industrial Economics](https://journals.openedition.org/rei/). The scripts are grouped per analytical purpose: 
1) to collect creators' contact info; 
2) to clean the creators' response to our survey; 
3) to compute a hierarchical clustering on principal components in order to gather respondents with similar production and monetisation strategies; 
4) to estimate the adoption factors for each creative production model.

## Goal of this research
This article examines the organisation of French online content creation through an analysis of the business models of creators active either on YouTube or Twitch. Our findings highlight similarities with the traditional creative endeavour, as there are disparities in the audience and revenue among content creators. Through a Hierarchical Clustering on Principal Components, we identify three distinct sets of production and monetization strategies (also referred to as creative models): amateur production, commercial endeavour in an indirect partnership with brands and advertisers, and commercial endeavour in a direct partnership with brands. Moreover, we find that the adoption of a creative model is linked with a creator’s choice of preferred platform, his videos’ genre and his audience size. These characteristics are key eligibility criteria in a platform’s monetisation policy. Our results shed additional light on the dependence relation between content creators and platforms.


## Presentation of the files
**Data_check.ipynb:** to check the consistency of participants answers to the survey. </p>
**Clustering_selection.ipynb:** selecting variables for clustering. </p>
**clustering_HCPC.R:**  computing hierarchical classification on principal components (HCPC). </p>
**Econometrics_selection.ipynb:** selecting variables for multinomial regressions. </p>
**econometrics.R** gathers all the variables coding for the ordered logistic regression. *(The econometric analysis is performed on Stata MP.)*
