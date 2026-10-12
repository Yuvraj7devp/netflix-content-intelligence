#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
from pathlib import Path

# Load the dataset from the project directory
project_dir = Path(__file__).resolve().parent
dataset_path = project_dir / "netflix_titles.csv"

raw_df = pd.read_csv(dataset_path)

print("Dataset loaded successfully.")
print(f"Dataset shape: {raw_df.shape}")

# In[4]:


raw_df['date_added'].isnull().sum()


# In[5]:


raw_df['date_added'].dropna().head(10)


# In[6]:


df = raw_df.copy()

df['date_added'] = pd.to_datetime(
    df['date_added'],
    format='%B %d, %Y',
    errors='coerce'
)


# In[7]:


raw_df['date_added'].dropna().head(10)


# In[8]:


df['year_added'] = df['date_added'].dt.year


# In[9]:


print("Missing date_added:", df['date_added'].isna().sum())
print("Missing year_added:", df['year_added'].isna().sum())


# In[10]:


raw_df['date_added'].dropna().head(20).tolist()


# In[11]:


raw_df['date_added'].dropna().tail(20).tolist()


# In[12]:


print(raw_df['date_added'].dtype)


# In[13]:


test_date = pd.to_datetime(
    raw_df['date_added'],
    errors='coerce'
)

problem_dates = raw_df[
    raw_df['date_added'].notna() & test_date.isna()
]['date_added']

print("Problematic dates:", len(problem_dates))
display(problem_dates.head(30))


# In[16]:


df = raw_df.copy()

df['date_added'] = pd.to_datetime(
    df['date_added'],
    format='mixed',
    errors='coerce'
)

df['year_added'] = df['date_added'].dt.year


# In[17]:


print("Missing date_added:", df['date_added'].isna().sum())
print("Missing year_added:", df['year_added'].isna().sum())


# In[18]:


null_summary = pd.DataFrame({
    'Null Count': df.isnull().sum(),
    'Null Percentage': (df.isnull().sum() / len(df) * 100).round(2)
})

display(null_summary[null_summary['Null Count'] > 0])


# In[20]:


df['director'] = df['director'].fillna('Unknown')
df['cast'] = df['cast'].fillna('Unknown')
df['country'] = df['country'].fillna('Unknown')


# In[21]:


df[df['rating'].isna()][
    ['show_id', 'title', 'type', 'rating']
]


# In[22]:


df['rating'] = df['rating'].fillna('Unknown')


# In[24]:


df[df['duration'].isna()][
    ['show_id', 'title', 'type', 'rating', 'duration']
]


# In[25]:


df['duration'] = df['duration'].fillna('Unknown')


# In[26]:


df.isnull().sum()


# In[27]:


print("Dataset Shape:", df.shape)

display(df.head())

print("\nMissing Values:")
display(df.isnull().sum())


# ## What type of content dominates Netflix's catalog?

# In[28]:


content_type = df['type'].value_counts()

display(content_type)


# In[29]:


content_percentage = (
    df['type'].value_counts(normalize=True) * 100
).round(2)

display(content_percentage)


# In[30]:


import matplotlib.pyplot as plt

content_type.plot(
    kind='bar',
    figsize=(7, 5)
)

plt.title('Netflix Content: Movies vs TV Shows')
plt.xlabel('Content Type')
plt.ylabel('Number of Titles')
plt.xticks(rotation=0)
plt.show()


# ### Top 10 Genres

# In[32]:


genres = df['listed_in'].dropna().str.split(', ')


# In[33]:


genre_count = genres.explode().value_counts()

display(genre_count.head(10))


# In[34]:


genre_count.head(10).sort_values().plot(
    kind='barh',
    figsize=(8, 6)
)

plt.title('Top 10 Netflix Genres')
plt.xlabel('Number of Titles')
plt.ylabel('Genre')
plt.show()


# In[ ]:





# ### Top 10 Countries

# In[35]:


countries = df['country'].replace('Unknown', pd.NA).dropna().str.split(', ')


# In[36]:


country_count = countries.explode().value_counts()

display(country_count.head(10))


# In[37]:


country_count.head(10).sort_values().plot(
    kind='barh',
    figsize=(8, 6)
)

plt.title('Top 10 Countries by Netflix Titles')
plt.xlabel('Number of Titles')
plt.ylabel('Country')
plt.show()


# ### Netflix Content Added by Year
# 

# In[38]:


content_by_year = (
    df['year_added']
    .value_counts()
    .sort_index()
)

display(content_by_year)


# In[39]:


content_by_year.plot(
    kind='line',
    figsize=(10, 5),
    marker='o'
)

plt.title('Netflix Content Added by Year')
plt.xlabel('Year')
plt.ylabel('Number of Titles Added')
plt.grid(True)
plt.show()


# ### Content Rating Analysis

# In[40]:


rating_count = df['rating'].value_counts()

display(rating_count)


# In[41]:


rating_count.head(10).sort_values().plot(
    kind='barh',
    figsize=(8, 6)
)

plt.title('Netflix Content by Rating')
plt.xlabel('Number of Titles')
plt.ylabel('Rating')
plt.show()


# ### Movies vs TV Shows Over Time

# In[42]:


content_year_type = pd.crosstab(
    df['year_added'],
    df['type']
)

display(content_year_type)


# In[43]:


content_year_type.plot(
    kind='line',
    figsize=(10, 6),
    marker='o'
)

plt.title('Movies vs TV Shows Added Over Time')
plt.xlabel('Year')
plt.ylabel('Number of Titles')
plt.show()


# ### What is the content distribution by year?

# In[44]:


yearly_content = df.groupby(
    ['year_added', 'type']
).size().unstack(fill_value=0)

display(yearly_content)


# In[45]:


df['year_added'].value_counts().sort_values(ascending=False).head(10)


# ### Which genres dominate Movies vs TV Shows?

# In[46]:


movie_genres = (
    df[df['type'] == 'Movie']['listed_in']
    .dropna()
    .str.split(', ')
    .explode()
    .value_counts()
)

tv_genres = (
    df[df['type'] == 'TV Show']['listed_in']
    .dropna()
    .str.split(', ')
    .explode()
    .value_counts()
)

print("Top Movie Genres")
display(movie_genres.head(10))

print("Top TV Show Genres")
display(tv_genres.head(10))


# ### Which countries contribute the most content? 

# In[47]:


movie_countries = (
    df[df['type'] == 'Movie']['country']
    .replace('Unknown', pd.NA)
    .dropna()
    .str.split(', ')
    .explode()
    .value_counts()
)

tv_countries = (
    df[df['type'] == 'TV Show']['country']
    .replace('Unknown', pd.NA)
    .dropna()
    .str.split(', ')
    .explode()
    .value_counts()
)

print("Top Movie-Producing Countries")
display(movie_countries.head(10))

print("Top TV Show-Producing Countries")
display(tv_countries.head(10))


# ### Analyze movie duration

# In[48]:


movies = df[df['type'] == 'Movie'].copy()

movies['duration_minutes'] = (
    movies['duration']
    .str.extract(r'(\d+)')
    .astype(float)
)


# In[49]:


movies['duration_minutes'].describe()


# In[50]:


movies['duration_minutes'].plot(
    kind='hist',
    bins=30,
    figsize=(9, 5)
)

plt.title('Distribution of Netflix Movie Durations')
plt.xlabel('Duration (Minutes)')
plt.ylabel('Number of Movies')
plt.show()


# ### TV Show season analysis

# In[52]:


tv_shows = df[df['type'] == 'TV Show'].copy()

tv_shows['seasons'] = (
    tv_shows['duration']
    .str.extract(r'(\d+)')
    .astype(float)
)


# In[53]:


tv_shows['seasons'].describe()


# In[54]:


tv_shows['seasons'].value_counts().sort_index().head(15)


# ### Advanced Analysis: Content Growth

# In[55]:


yearly_total = (
    df.groupby('year_added')
    .size()
    .sort_index()
)

yoy_growth = yearly_total.pct_change() * 100

growth_df = pd.DataFrame({
    'Titles Added': yearly_total,
    'YoY Growth %': yoy_growth.round(2)
})

display(growth_df)


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




