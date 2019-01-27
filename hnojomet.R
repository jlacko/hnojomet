library(tidyverse)
library(rtweet)

# soubor je gitignorován coby nerelevantní; postup získání a uložení tokenu
# je popsán na dokumentaci package rtweet: https://rtweet.info/#create-an-app
twitter_token <- readRDS("token.rds")

hledanyText <- "Klaus OR Klause OR Klausem OR Klausovi OR @VaclavKlaus_ml"

dnes <- as.character(Sys.Date()) # dnešek
vcera <- as.character(Sys.Date() - 1) # včerejšek


tweets <- search_tweets(hledanyText, # Klaus, prostě Klaus
                        n = 5000,  # tolik tweetů za den nebude, ale co kdyby...
                        lang = "cs", # šak sme česi, né?
                        since = vcera, # od včerejška...
                    #    until = dnes,
                        token = twitter_token) %>% # ...do dneška 
  select(id = status_id, 
         name = screen_name, 
         created = created_at,
         text, 
         source,
         lajku = favorite_count,
         retweetu = retweet_count)

sprostarny <- c('Václav Klaus Jr. má malý penis',
                'Václav Klaus Jr. opisoval při maturitě',
                'Václav Klaus Jr. jí chrousty, psy a kočky',
                'Václav Klaus Jr. kradl tatínkovi tužky')


for (i in seq_along(tweets$text)) {
  urazka <- paste0('A víš, @', tweets$name,', že ', sample(sprostarny, 1),'?')
  
  post_tweet(status = urazka, 
             token = twitter_token, 
             in_reply_to_status_id = tweets$id)
  
}