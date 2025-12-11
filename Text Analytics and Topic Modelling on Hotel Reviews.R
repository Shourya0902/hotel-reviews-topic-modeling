#Text Analytics and Topic Modelling on Hotel Reviews

install.packages("tm")
install.packages("tokenizers")
install.packages("SnowballC")
install.packages("textstem")
install.packages('gutenbergr')
install.packages("fmsb")


# Add packages to Library
library(tidyverse)      
library(tm)             
library(topicmodels)    
library(stringr)        
library(tidytext)       
library(wordcloud)     
library(RColorBrewer)   
library(ggplot2)        
library(ldatuning)     
library(textstem)      
library(LDAvis)         
library(servr)          
library(gridExtra)      
library(igraph)
library(ldatuning)
library(fmsb)

#Loading the data
data = read.csv("HotelsData.csv")
str(data)

#Setting seed with last three digits 
set.seed(311)

#Sampling 2000 reviews
sample = sample_n(data, 2000)
sample = as.data.frame(sample)
head(sample)
str(sample)

#Defining column names for convenience
colnames(sample) <- c("review_score", "review_text")

#Changing datatype of review_score
sample$review_score <- as.factor(sample$review_score)

#Checking for missing values
sum(is.na(sample$review_score))
sum(is.na(sample$review_text))

#Analyzing review_score column
summary(sample$review_score)
review_score_counts <- table(sample$review_score)
review_score_percentages <- prop.table(review_score_counts) * 100

#Forming a bar chart for counts of review score
ggplot(sample, aes(x = factor(review_score))) + geom_bar(fill = "lightblue") +
       labs(title = "Count of Review Scores",
       x = "Review Score",
       y = "Count",
       subtitle = paste("No. of Reviews =", nrow(sample))) + theme_minimal() +
       geom_text(stat='count', aes(label=paste0(round(after_stat(count)/sum(after_stat(count))*100, 1), "%")), vjust=-0.5)

#Calculating text length and putting this as column
sample$text_length <- nchar(sample$review_text)
summary(sample$text_length)


# Text length distribution graph
ggplot(sample, aes(x = text_length)) +
  geom_histogram(binwidth = 50, fill = "steelblue", color = "black") +
  labs(title = "Distribution of Review Text Length",
       x = "Number of Characters",
       y = "Count",
       subtitle = paste("Mean =", round(mean(sample$text_length), 1))) +
  theme_minimal()

#Detecting language of the text
sample$language <- cld2::detect_language(sample$review_text)
language_counts <- table(sample$language)
print(language_counts)

# Language distribution graph
language_df <- as.data.frame(language_counts)
colnames(language_df) <- c("Language", "Count")
language_df$Percentage <- language_df$Count / sum(language_df$Count) * 100

ggplot(language_df, aes(x = reorder(Language, -Count), y = Count)) +
  geom_bar(stat = "identity", fill = "darkgreen") +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")), vjust = -0.5) +
  labs(title = "Distribution of Review Languages",
       x = "Language", 
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Removing other languages and keeping only English language rows
sample <- subset(sample, language == "en")
sample
#******************************************************************************

# TEXT PREPROCESSING
corpus <- Corpus(VectorSource(sample$review_text))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, content_transformer(lemmatize_strings))
corpus <- tm_map(corpus, content_transformer(
  function(x) {
  x <- gsub("\\b[a-z]\\b", " ", x)
  x <- gsub("’", " ", x)  
  x <- gsub("\\s+", " ", x)
  x <- trimws(x)
  return(x)}))

#Create document term matrix
dtm <- DocumentTermMatrix(corpus)
dtm
dtm_sparse <- removeSparseTerms(dtm, 0.99)

# Term frequency analysis
freq <- sort(colSums(as.matrix(dtm_sparse)), decreasing=TRUE)
wordcloud(names(freq), freq, max.words=50, colors=brewer.pal(8, "Dark2"))

# Separate positive and negative reviews
positive_reviews <- subset(sample, review_score %in% c("4", "5"))
negative_reviews <- subset(sample, review_score %in% c("1", "2"))

# Create separate corpora for positive and negative reviews
positive_corpus <- Corpus(VectorSource(positive_reviews$review_text))
negative_corpus <- Corpus(VectorSource(negative_reviews$review_text))

# Apply same preprocessing with lemmatization
positive_corpus <- tm_map(positive_corpus, content_transformer(tolower))
positive_corpus <- tm_map(positive_corpus, removePunctuation)
positive_corpus <- tm_map(positive_corpus, removeNumbers)
positive_corpus <- tm_map(positive_corpus, removeWords, stopwords("english"))
positive_corpus <- tm_map(positive_corpus, lemmatize_strings)  

negative_corpus <- tm_map(negative_corpus, content_transformer(tolower))
negative_corpus <- tm_map(negative_corpus, removePunctuation)
negative_corpus <- tm_map(negative_corpus, removeNumbers)
negative_corpus <- tm_map(negative_corpus, removeWords, stopwords("english"))
negative_corpus <- tm_map(negative_corpus, lemmatize_strings)  


# Create DTMs for positive and negative reviews
positive_dtm <- DocumentTermMatrix(positive_corpus)
negative_dtm <- DocumentTermMatrix(negative_corpus)

# Get frequent terms
positive_freq <- sort(colSums(as.matrix(positive_dtm)), decreasing=TRUE)
negative_freq <- sort(colSums(as.matrix(negative_dtm)), decreasing=TRUE)

# Compare top terms
head(positive_freq, 20)
head(negative_freq, 20)

# Create wordclouds for comparison
par(mfrow=c(1,2))
wordcloud(names(positive_freq), positive_freq, max.words=30, main="Positive")
wordcloud(names(negative_freq), negative_freq, max.words=30, main="Negative")
par(mfrow=c(1,1))
#******************************************************************************

# MODELLING

#Ldatuning
postive_dtm_k <- FindTopicsNumber(
  positive_dtm, topics = seq(from = 5, to = 10, by = 1),
  metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010"),
  method = "Gibbs", control = list(seed = 77),
  mc.cores = 2L, verbose = TRUE)
postive_dtm_k

negative_dtm_k <- FindTopicsNumber(
  negative_dtm, topics = seq(from = 5, to = 10, by = 1),
  metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010"),
  method = "Gibbs", control = list(seed = 77),
  mc.cores = 2L, verbose = TRUE)
negative_dtm_k

par(mfrow=c(1,2))
FindTopicsNumber_plot(postive_dtm_k)
FindTopicsNumber_plot(negative_dtm_k)
par(mfrow=c(1,2))

k_positive <- 10
k_negative <- 10

#Performing LDA
LDA_positive = LDA(positive_dtm, k = k_positive, method="Gibbs",  control=list(iter=1000,seed=1234))
LDA_negative = LDA(negative_dtm, k = k_negative, method="Gibbs",  control=list(iter=1000,seed=1234))  

phi_positive = posterior(LDA_positive)$terms %>% as.matrix 
phi_positive = posterior(LDA_negative)$terms %>% as.matrix 

theta_positive = posterior(LDA_positive)$topics %>% as.matrix 
theta_negative = posterior(LDA_negative)$topics %>% as.matrix 


# Extract top terms from LDA models (already fitted)
top_terms_pos <- terms(LDA_positive, 10)
top_terms_neg <- terms(LDA_negative, 10)

print("Top terms in positive reviews:")
print(top_terms_pos)

print("Top terms in negative reviews:")
print(top_terms_neg)

#Converting to data frames for plotting
num_topics_pos <- ncol(top_terms_pos)
num_topics_neg <- ncol(top_terms_neg)

#Preparing data for positive reviews
pos_terms_df <- do.call(rbind, lapply(1:num_topics_pos, function(i) {
  data.frame(
    term = top_terms_pos[, i],
    rank = 10:1,
    topic = paste("Topic", i)
  )
}))

#Preparing data for negative reviews
neg_terms_df <- do.call(rbind, lapply(1:num_topics_neg, function(i) {
  data.frame(
    term = top_terms_neg[, i],
    rank = 10:1,
    topic = paste("Topic", i)
  )
}))

#Custom colors
custom_colors <- rep(c("#FF6B6B", "#59CD90", "#3FA7D6", "#9775AA", "#F8A055"), 2)

#Plotting for positive reviews
ggplot(pos_terms_df, aes(x = reorder(term, rank), y = rank, fill = topic)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free_y", ncol = 3) +
  scale_fill_manual(values = custom_colors) +
  coord_flip() +
  labs(title = "Top Terms by Topic - Positive Reviews", x = "Terms", y = "Importance") +
  theme_minimal()

#Plotting for negative reviews
ggplot(neg_terms_df, aes(x = reorder(term, rank), y = rank, fill = topic)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free_y", ncol = 3) +
  scale_fill_manual(values = custom_colors) +
  coord_flip() +
  labs(title = "Top Terms by Topic - Negative Reviews", x = "Terms", y = "Importance") +
  theme_minimal()

#Getting weights
pos_topic_proportions <- colSums(posterior(LDA_positive)$topics) / nrow(posterior(LDA_positive)$topics)
# Convert to percentages and round
pos_topic_percentages <- round(pos_topic_proportions * 100, 1)
# Print the percentages for each topic
for (i in 1:length(pos_topic_percentages)) {
  cat("Topic", i, ":", pos_topic_percentages[i], "%\n")}

neg_topic_proportions <- colSums(posterior(LDA_negative)$topics) / nrow(posterior(LDA_negative)$topics)
# Convert to percentages and round
neg_topic_percentages <- round(neg_topic_proportions * 100, 1)
# Print the percentages for each topic
for (i in 1:length(neg_topic_percentages)) {
  cat("Topic", i, ":", neg_topic_percentages[i], "%\n")}