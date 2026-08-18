
#Load packages
library(tidyverse)
library(xml2)
library(tidytext)
library(ggwordcloud)

        
#Unzip data set in the data folder. Data is loaded
adl <- read.csv2("data/public_domain_adl_dataset/mekuni_adl_dataset/adl_dataset_metadata.csv")



#Text is loaded into R from the xml files

adl <- adl %>% 
  mutate(xml_file_name = str_c("data/public_domain_adl_dataset/mekuni_adl_dataset/", xml_file_name))


adl <- adl %>% 
  mutate(
    text = map_chr(xml_file_name, ~
                     read_xml(.x) %>% 
                     xml_find_all("//d1:body//text()", ns = xml_ns(read_xml(.x))) %>% 
                     xml_text() %>% 
                     str_squish() %>%
                     str_c(collapse = " ")
    )
  )

# Choosing years after the death of the author works still count
year_after_death <- 10

# Remove works published too long after the author's death
adl <- adl %>% 
  filter(
    is.na(death_year) | 
      year <= death_year + year_after_death
  )

# Divide the texts into three chronological periods
period_1_start <- 1800
period_1_end   <- 1870

period_2_start <- 1871
period_2_end   <- 1900

period_3_start <- 1901
period_3_end   <- 1945


# Divide the texts into  chronological periods

adl <- adl %>%
  mutate(
    period = case_when(
      year >= period_1_start & year <= period_1_end ~
        paste0(period_1_start, "-", period_1_end),
      
      year >= period_2_start & year <= period_2_end ~
        paste0(period_2_start, "-", period_2_end),
      
      year >= period_3_start & year <= period_3_end ~
        paste0(period_3_start, "-", period_3_end),
      
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(period))

# Load the ADL stopwords
stopwords_adl <- read_lines(
  "data/public_domain_adl_dataset/mekuni_adl_dataset/adl_dataset_stopwords.txt"
) %>% 
  tibble(word = .) %>% 
  mutate(word = str_to_lower(word))

# Manually add stopwords (all lowercase), like proper names of characters in the novels

new_stopwords <- c("sae", "æ","joán","saá", "tine", "flemming", "erik", "ellen", "margrete", "birkner", "sølver", "konni", "aaløv", "beate", "hellen", "lise", "willibald", "helene", "asmadæus", "tue", "mikael", "jespersen", "katinka", "thomas", "kræsten", "alice", "ida", "hyldgaard",
                   "melson", "eggert", "reimert", "neergaard", "mengel", "florizel", "mikaël", "vanda", "kragh", "fulvia", "nini", "leuning", "repholt", "herta")

stopwords_adl <- stopwords_adl %>%
  bind_rows(tibble(word = new_stopwords))


# Turn text into individual words and remove stop words
adl_words <- adl %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stopwords_adl, by = "word")



# Calculate TF-IDF for each period
adl_tfidf <- adl_words %>% 
  count(period, word, sort = TRUE) %>% 
  bind_tf_idf(word, period, n)

# Word clouds based on TF-IDF
adl_tfidf %>% 
  group_by(period) %>% 
  slice_max(tf_idf, n = 25) %>% 
  ungroup() %>% 
  ggplot(aes(
    label = word,
    size = tf_idf
  )) +
  geom_text_wordcloud_area() +
  scale_size_area(max_size = 12) +
  facet_wrap(~period, ncol = 3, scales = "free") +
  theme_minimal() +
  labs(
    title = "Words characteristic of each historical period",
    size = "TF-IDF"
  )


# Bar chart based on TF-IDF
adl_tfidf %>% 
  group_by(period) %>% 
  slice_max(tf_idf, n = 25) %>% 
  ungroup() %>% 
  ggplot(aes(
    x = reorder(word, tf_idf),
    y = tf_idf
  )) +
  geom_col() +
  coord_flip() +
  facet_wrap(~period, ncol = 3, scales = "free") +
  theme_minimal() +
  scale_y_continuous(labels = function(x) format(x * 1000, digits = 1, nsmall = 1),
                     n.breaks = 3) +
  labs(
    title = "Words characteristic of each historical period",
    x = "Word",
    y = "TF-IDF"
  )

