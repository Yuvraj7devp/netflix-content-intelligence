# Netflix Content Intelligence & Catalog Analytics

## About the Project

I worked on this project to explore Netflix's content catalog and understand how its movies and TV shows are distributed across different years, genres, countries, and content ratings.

The project gave me an opportunity to work with the same dataset across multiple tools. I used Python for data inspection and exploratory analysis, PostgreSQL for SQL-based analysis, and Power BI to build an interactive dashboard.

The main goal was to turn the raw data into useful insights about Netflix's content library.

## Tools Used

- Python (Pandas)
- PostgreSQL
- SQL
- Power Query
- Power BI
- DAX

## Dataset Overview

The dataset contains information about Netflix movies and TV shows, including:

- Title and content type
- Director and cast
- Country
- Date added to Netflix
- Release year
- Content rating
- Movie duration or TV show seasons
- Listed genres
- Description

The dataset contains 8,807 records and 12 columns.

## What I Worked On

- Inspected the dataset and checked missing values.
- Explored the distribution of movies and TV shows.
- Analysed content by release year, country, genre, and rating.
- Used SQL queries to answer questions about the catalog.
- Prepared separate Genre and Country tables for Power BI analysis.
- Created DAX measures for key metrics.
- Built an interactive dashboard to explore the results.

## Key Findings

- Movies account for approximately 69.6% of the titles in the dataset, while TV shows account for 30.4%.
- The United States and India have the highest country-associated title counts in the analysis.
- International Movies, Dramas, and Comedies are among the most common genre categories.
- TV-MA is the most frequent content rating in the dataset.
- The number of titles by release year peaks in 2018.

These findings describe the dataset used in this project. They should not be interpreted as Netflix's current catalog statistics.

## Dashboard

The Power BI dashboard includes:

- Total titles, movies, and TV shows
- Content type distribution
- Titles by release year
- Movies versus TV shows by release year
- Content rating distribution
- Top 10 genres
- Top 10 countries by title associations
- Filters for content type, release year, rating, and genre

A dashboard screenshot will be added here.

## Project Structure

```text
netflix-content-intelligence/
│
├── data/
│   └── README.md
│
├── notebooks/
│
├── python/
│   └── README.md
│
├── sql/
│   └── README.md
│
├── powerbi/
│   └── README.md
│
├── screenshots/
│
├── documentation/
│   ├── Netflix_Content_Intelligence_Project_Documentation.docx
│   └── portfolio-readiness-checklist.md
│
└── README.md
