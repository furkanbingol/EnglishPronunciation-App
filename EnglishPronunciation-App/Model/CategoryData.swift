//
//  CategoryData.swift
//  EnglishPronunciation-App
//
//  Created by Furkan Bingöl on 10.04.2023.
//

import Foundation
import UIKit


// Singleton Class
class CategoryData {
    static let shared = CategoryData()
    var categories = [Category]()
    var selectedCategoryNumber = 0
    var selectedCategoryNumberInRepeatPage = 0
    var option = ""
    var selectedWordInRepeatPage = Word()
    
    private init() {}
    
    let docNames = ["A1 - Greetings and Introductions", "A1 - Numbers and Counting", "A1 - Colors", "A1 - Days, Months and Seasons",
                    "A1 - Family Members", "A1 - Food and Drinks", "A1 - Basic Daily Activities", "A1 - Simple Questions and Responses",
                    "A2 - Hobbies and Interests", "A2 - Travel and Transportation", "A2 - Health and Fitness", "A2 - Education and Learning",
                    "A2 - Weather and Climate", "A2 - Technology and Gadgets", "A2 - Culture and Traditions", "B1 - Relationships and Dating",
                    "B1 - Sports and Athletics", "B1 - Business and Finance", "B1 - Fashion and Style", "B1 - Environment and Sustainability",
                    "B1 - History and Politics", "B1 - Science and Technology", "B1 - Holidays and Celebrations",
                    "B1 - Social Issues and Ethics", "B2 - Literature and Poetry", "B2 - Philosophy and Ethics", "B2 - Art and Architecture",
                    "B2 - Psychology and Mental Health", "B2 - Advertising and Marketing", "B2 - Law and Justice",
                    "C1 - Advanced Grammar and Syntax", "C1 - Idioms and Phrasal Verbs", "C1 - Academic Writing and Research",
                    "C1 - Linguistics and Language Acquisition", "C1 - Entrepreneurship and Innovation",
                    "C1 - Creative Writing and Storytelling", "C1 - Public Speaking and Presentation Skills", "C1 - Film and Cinema Industry",
                    "C2 - Professional Writing and Editing", "C2 - Literary Criticism and Analysis",
                    "C2 - Advanced Communication Strategies", "C2 - The Future of Artificial Intelligence"]
    
    let smallImageNames = ["1-a1-greetings-small", "2-a1-numbers-small", "3-a1-colors-small", "4-a1-days-months-small", "5-a1-family-small",
                           "6-a1-food-small", "7-a1-daily-activity-small", "8-a1-simple-questions-small", "1-a2-hobby-small",
                           "2-a2-travel-small", "3-a2-health-small", "4-a2-education-small", "5-a2-weather-small", "6-a2-technology-small",
                           "7-a2-culture-small", "1-b1-relationships-small", "2-b1-sports-small", "3-b1-business-small", "4-b1-fashion-small",
                           "5-b1-environment-small", "6-b1-history-small", "7-b1-science-small", "8-b1-holidays-small",
                           "9-b1-social-issues-small", "1-b2-poetry-small", "2-b2-philosophy-small", "3-b2-architecture-small",
                           "4-b2-mental-health-small", "5-b2-marketing-small", "6-b2-law-small", "1-c1-advanced-grammar-small",
                           "2-c1-idioms-small", "3-c1-academic-writing-small", "4-c1-linguistics-small", "5-c1-entrepreneurship-small",
                           "6-c1-storytelling-small", "7-c1-presentation-small", "8-c1-film-small", "1-c2-prof-writing-small",
                           "2-c2-literary-small", "3-c2-adv-communication-small", "4-c2-ai-small"]
    
    let largeImageNames = ["1-a1-greetings-large", "2-a1-numbers-large", "3-a1-colors-large", "4-a1-days-months-large", "5-a1-family-large",
                           "6-a1-food-large", "7-a1-daily-activity-large", "8-a1-simple-questions-large", "1-a2-hobby-large",
                           "2-a2-travel-large", "3-a2-health-large", "4-a2-education-large", "5-a2-weather-large", "6-a2-technology-large",
                           "7-a2-culture-large", "1-b1-relationships-large", "2-b1-sports-large", "3-b1-business-large", "4-b1-fashion-large",
                           "5-b1-environment-large", "6-b1-history-large", "7-b1-science-large", "8-b1-holidays-large",
                           "9-b1-social-issues-large", "1-b2-poetry-large", "2-b2-philosophy-large", "3-b2-architecture-large",
                           "4-b2-mental-health-large", "5-b2-marketing-large", "6-b2-law-large", "1-c1-advanced-grammar-large",
                           "2-c1-idioms-large", "3-c1-academic-writing-large", "4-c1-linguistics-large", "5-c1-entrepreneurship-large",
                           "6-c1-storytelling-large", "7-c1-presentation-large", "8-c1-film-large", "1-c2-prof-writing-large",
                           "2-c2-literary-large", "3-c2-adv-communication-large", "4-c2-ai-large"]
    
}
