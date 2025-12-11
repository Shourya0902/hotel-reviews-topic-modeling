# Hotel Review Intelligence System using NLP & Topic Modeling

Automated text analytics system that extracts actionable insights from 10,000+ hotel reviews using NLP techniques, sentiment analysis, and Latent Dirichlet Allocation (LDA) topic modeling.

## 📊 Project Overview

Analyzed **10,000 hotel reviews** across **15 languages** to identify key drivers of customer satisfaction and pain points. Discovered **10 distinct topics** in both positive and negative feedback, enabling data-driven hotel management decisions.

## 🎯 Key Results

- **Sample Size:** 2,000 reviews (stratified random sampling)
- **Languages Detected:** 15 (focused on English: 1,619 reviews)
- **Topics Identified:** 20 total (10 positive + 10 negative themes)
- **Topic Balance:** Near-equal importance (9.5%-10.4%) across all factors
- **Key Insight:** Customers evaluate hotels holistically - all factors matter equally

## 📁 Dataset

- **Total Reviews:** 10,000
- **Rating Scale:** 1-5 (Likert scale)
- **Sample:** 2,000 reviews (reproducible with seed=311)
- **Distribution:** 
  - Positive (4-5 stars): 68% (1,360 reviews)
  - Negative (1-2 stars): 32% (440 reviews)

## 🔧 Methodology

### 1. Text Preprocessing Pipeline
```r
Text Normalization → Noise Removal → Stopword Removal → Lemmatization → DTM Creation
```

**Preprocessing Steps:**
- Convert to lowercase
- Remove punctuation and numbers
- Remove English stopwords
- Lemmatization (reduce words to base forms)
- Remove sparse terms (99% threshold)

### 2. Topic Modeling (LDA)
- **Algorithm:** Latent Dirichlet Allocation
- **Optimization:** Tested 5-10 topics using ldatuning package
- **Metrics:** Griffiths2004, CaoJuan2009, Arun2010
- **Optimal Topics:** k=10 for both positive and negative reviews
- **Training:** Gibbs sampling (1,000 iterations, burn-in=100)

### 3. Sentiment Segmentation
Reviews split by rating:
- **Positive Corpus:** Ratings 4-5
- **Negative Corpus:** Ratings 1-2

## 📊 Key Findings

### 🟢 Positive Review Topics (10 themes):

| Topic | Theme | Weight | Key Terms |
|-------|-------|--------|-----------|
| 1 | Overnight Stay Experience | 9.9% | hotel, room, stay, good |
| 2 | Location & Accessibility | 9.6% | location, bar, restaurant, area |
| 3 | Transport Connectivity | 10.3% | station, train, walk, metro |
| 4 | City Experience | 10.1% | city, center, location, business |
| 5 | Room & Service Quality | 9.9% | room, clean, comfortable, spacious |
| 6 | Free Breakfast | 9.8% | breakfast, food, amenities |
| 7 | Room Attributes | 10.2% | bed, size, bathroom, facilities |
| 8 | Booking Experience | 9.9% | book, price, value, online |
| 9 | Overall Stay | 9.9% | stay, experience, recommend |
| 10 | Staff Interactions | 10.4% | staff, friendly, helpful, service |

### 🔴 Negative Review Topics (10 themes):

| Topic | Theme | Weight | Key Terms |
|-------|-------|--------|-----------|
| 1 | Poor Night Experience | 10.4% | night, noise, sleep, loud |
| 2 | Location Problems | 10.1% | far, walk, inconvenient, distance |
| 3 | Unmet Expectations | 10.1% | expect, better, disappointed |
| 4 | Room Availability | 10.3% | room, book, available, shortage |
| 5 | Bad Night/Breakfast | 9.8% | night, morning, breakfast, poor |
| 6 | Pricing Issues | 9.9% | money, charge, expensive, price |
| 7 | Service Problems | 9.8% | service, problem, issue, bad |
| 8 | Cleanliness Concerns | 9.5% | dirty, clean, old, standard |
| 9 | Check-in/out Issues | 10.2% | check, reception, wait, desk |
| 10 | Room Quality | 9.8% | small, shower, bed, uncomfortable |

## 📈 Visualizations

### Word Clouds
![Positive Reviews](results/wordcloud_positive.png)
![Negative Reviews](results/wordcloud_negative.png)

### Topic Distribution
![Positive Topics](results/topics_positive.png)
![Negative Topics](results/topics_negative.png)

### Review Distribution
![Rating Distribution](results/rating_distribution.png)

## 🛠️ Technical Stack

- **Language:** R
- **Libraries:**
  - `tm` - Text mining
  - `topicmodels` - LDA implementation
  - `textstem` - Lemmatization
  - `ldatuning` - Optimal topic selection
  - `wordcloud` - Visualization
  - `tidytext` - Tidy text analysis
  - `ggplot2` - Advanced plotting

## 💼 Business Recommendations

### Actionable Insights:

1. **Staff Training Programs**
   - Staff appears in both positive (10.4%) and negative reviews
   - Implement comprehensive customer service training
   - Focus on problem-solving and empathy

2. **Room Quality Optimization**
   - Address cleanliness, size, and facility issues
   - Regular maintenance schedules
   - Upgrade old fixtures and furniture

3. **Streamlined Check-in/Check-out**
   - Implement self-service kiosks
   - Mobile check-in options
   - Better staff training at reception

4. **Food & Amenities Enhancement**
   - Breakfast is a key differentiator (9.8% positive)
   - Improve breakfast menu variety
   - Highlight complimentary offerings

5. **Noise Management**
   - Major pain point (10.4% negative)
   - Soundproofing improvements
   - Guest room placement strategy

## 🚀 How to Run
```r
# Install required packages
install.packages(c("tm", "topicmodels", "textstem", "ldatuning", "wordcloud", "tidytext"))

# Load libraries
library(tm)
library(topicmodels)
library(textstem)

# Set seed for reproducibility
set.seed(311)

# Run the script
source("code/Text_Analytics_Hotel_Reviews.R")
```

## 📊 Model Validation

- **Optimal k selection:** ldatuning package with 3 metrics
- **Topic coherence:** Manual review of top terms
- **Business relevance:** Validated topics with domain experts
- **Representative reviews:** Extracted for each topic

## 🔍 Future Improvements

- **Multilingual analysis:** Extend beyond English reviews
- **Sentiment scoring:** Implement fine-grained sentiment analysis
- **Real-time monitoring:** Dashboard for live review tracking
- **Competitor benchmarking:** Compare topics across hotel chains
- **Aspect-based sentiment:** Link sentiment to specific aspects (room, staff, food)

## 📝 Project Structure
```
├── code/
│   └── Text_Analytics_Hotel_Reviews.R    # Main analysis script
├── data/
│   └── HotelsData.csv                    # Raw review data
├── results/
│   └── *.png                             # Visualizations
└── README.md                             # This file
```

## 👨‍💻 Author

**Shourya Marwaha**
- LinkedIn: [linkedin.com/in/ShouryaMarwaha](https://linkedin.com/in/ShouryaMarwaha)
- Email: shouryamarwaha@gmail.com

## 📄 License

This project is available for educational and portfolio purposes.

## 🙏 Acknowledgments

- Dataset source: Hotel review aggregation platform
- Academic guidance: University of Leeds, LUBS5309M module
- Topic modeling inspiration: Blei et al. (2003) - LDA paper
