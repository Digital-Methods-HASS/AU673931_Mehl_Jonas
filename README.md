# Period Analysis of Danish Literature

## Project overview

This project uses text mining to investigate how the characteristic vocabulary of Danish literary works changes across three historical periods:

- **1800–1870:** Before the Modern Breakthrough
- **1871–1900:** The Modern Breakthrough
- **1901–1945:** After the Modern Breakthrough

The analysis uses **TF-IDF (term frequency–inverse document frequency)** to identify words that are particularly characteristic of each period.

The project accompanies a written report discussing the results and their literary-historical context.

## Software

The analysis was conducted using:

- RStudio version 2026.7.1.147
- R version 4.6.1

R packages used:

- tidyverse 2.0.0
- xml2 1.6.0
- tidytext 0.4.3
- ggwordcloud 0.6.2

## Data

The dataset is provided by the **Danish Royal Library**.

**Dataset:** *Arkiv for Dansk Litteratur: tekster uden for ophavsret*

**Download:** https://loar.kb.dk/handle/1902/49121

**License:** Public Domain Mark 1.0

More information about the creation of the dataset can be found at:

https://www.kb.dk/en/services/cultural-heritage-research-and-study/cultural-heritage-data-and-datasets/archive-danish-literature

## To run

1. Download the dataset from the Danish Royal Library.
2. Unzip the dataset into the `data` folder.
4. Run `TF-IDF.R` in RStudio

### Expected folder structure

After downloading and unzipping the dataset, the project should contain the data in the following general structure:

```text
.
├── data/
│   └── public_domain_adl_dataset/
│       └── mekuni_adl_dataset/
│           ├── adl_dataset_metadata.csv
│           ├── adl_dataset_stopwords.txt
│           └── *.xml
├── TF-IDF.R
└── README.md
