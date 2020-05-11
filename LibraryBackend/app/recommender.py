import sys, json, numpy as np
import io
from rake_nltk import Rake
import pandas as pd
from pandas import Series,DataFrame
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import CountVectorizer

#Read data from stdin
def read_in():
    lines = sys.stdin.readlines()
    #print(lines[0])
    return json.loads(lines[0])

def main():
    #get the data as an array from read_in()
    bookId = int(sys.argv[1])
    jsonData = read_in()
    pd.read_json(json.dumps(jsonData)).to_csv("data.csv")
    df = pd.read_csv("data.csv")
    df['keywords'] = ''
    r = Rake()
    for index, row in df.iterrows():
        r.extract_keywords_from_text(row['description'])
        key_words_dict_scores = r.get_word_degrees()
        row['keywords'] = list(key_words_dict_scores.keys())
        df.at[index, 'keywords'] = row['keywords']
    
    for index, row in df.iterrows():
        row['subject'] = [x.lower() for x in row['subject']]

    df['Bag_of_words'] = ''
    columns = ['subject', 'keywords']
    for index, row in df.iterrows():
        words = ''
        for col in columns:
            words += ''.join(row[col]) + ' '
        row['Bag_of_words'] = words
        df.at[index, 'Bag_of_words'] = row['Bag_of_words']

    df = df[['bid','Bag_of_words']]
    count = CountVectorizer()
    count_matrix = count.fit_transform(df['Bag_of_words'])
    cosine_sim = cosine_similarity(count_matrix, count_matrix)
    indices = pd.Series(df['bid'])
    recommended_books = []
    idx = indices[indices == bookId].index[0]
    score_series = pd.Series(cosine_sim[idx]).sort_values(ascending = False)
    top_indices = list(score_series.iloc[1:6].index)
    for i in top_indices:
        recommended_books.append(list(df['bid'])[i])
    recommended_books_dict = []
    [recommended_books_dict.append(jsonData[x-1]) for x in recommended_books if not x == bookId and jsonData[x-1] not in recommended_books_dict]
    print(json.dumps(recommended_books_dict))
    

#start process
if __name__ == '__main__':
    main()