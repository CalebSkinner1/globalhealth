# Global Health Data Analysis 2
# Author: Katie Clewett
# Last Modified: November 1

library(ggplot2)
library(tidyverse)
library(rjags)
library(ProbBayes)
library(bayesplot)
library(rstanarm)
library(forcats)
library(readr)
library(stringr)
library(scales)
library(ggpubr)
library(broom)
library(AICcmodavg)
library(waffle)

# loading df- helpful for viewing the questions
df0 <- read.csv("Global_Health_data.csv") %>%
  select(20,22:24,26,28,30,36,38:45,47:50) # %>% view()

# removing excess rows and fixing bad responses
df <- df0[-c(1:2),] %>% 
  mutate(Q17 = recode(Q17,
                      'Strongly Agree ' = 'Strongly Agree',
                      'Undecided ' = 'Undecided',
                      'Strongly Disagree ' = 'Strongly Disagree'),
         Q22 = recode(Q22,
                      'Strongly Agree ' = 'Strongly Agree',
                      'Undecided ' = 'Undecided',
                      'Strongly Disagree ' = 'Strongly Disagree'),
         Q14 = recode(Q14,
                      'No ' = 'No'),
         Q13 = recode(Q13,
                      '15+ years ' = '15+ years',
                      '5 - 10 years ' = '5 - 10 years',
                      '10 - 15 years ' = '10 - 15 years',
                      '1 - 5 years ' = '1 - 5 years',
                      'Less than one year ' = 'Less than one year'
         ),
         Q6 = recode(Q6,
                     'Pre-professional track - only choose this option if you do not have another major that fits into one of the above categories ' = 'Pre-Professional Track')
  ) # %>% view()

# Results of Q18
  # Responses to sufficient number of opportunities in global health for pre-med students (Q18)
  df18 <- df %>% 
    filter(Q18 != "") %>% view()
  # set yes = 1, unsure = .5, and no = 0 for t tests
  df18ttest <- df18 %>%
    mutate(Q18 = case_when(
      Q18 == "Unsure" ~ .5,
      Q18 == "Yes" ~ 1,
      Q18 == "No" ~ 0)
    ) # %>% view()
  
  # Bar Graph
  df18 %>%
    group_by(Q18) %>%
    summarise(
      Counts = n()
    ) %>% ggplot(aes(Q18, Counts)) +
    geom_bar(stat = "identity", fill = 'cornsilk3') +
    labs(title = "Are there enough global health opportunities for pre-med students?", x = "Responses") +
    geom_text(aes(label = signif(Counts)), nudge_y = 2)

# How do the results of sufficient number or opportunities in global health for pre-med students (Q18) correlate with stated interest in global health (Q14)
  df18 %>%
    filter(Q14 != "") %>% 
    group_by(Q14, Q18) %>%
    summarise(
      Counts = n()
    ) %>%
    ggplot(aes(Q14, Counts, fill = Q18)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = "Opportunities in Global Health by Global Health Career Interest", x = "Global Health Career Interest",
         fill = "Enough Opportunities in Global Health for Pre-Med Students:") +
    theme(legend.position = "bottom") +
    geom_text(aes(label = signif(Counts)), vjust = -.1, position = position_dodge(width = .9))
  