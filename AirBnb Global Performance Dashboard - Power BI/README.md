# 🏠 Global Airbnb Performance Dashboard

An end-to-end Power BI dashboard analyzing Airbnb's global performance across 10 major cities — covering listing growth, pricing, host verification/trust, review behavior, and city-level ratings.

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black)
![Power Query](https://img.shields.io/badge/Power%20Query-217346?style=flat&logo=powerbi&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-orange?style=flat)

---

## 📌 Overview

This project explores Airbnb's global footprint using two raw CSV datasets — **Listings** and **Reviews** — transformed in Power Query, modeled with custom DAX measures, and visualized across a 3-page interactive Power BI report.

The goal was to answer key business questions:
- How has Airbnb's listing growth evolved over time, and how did COVID-19 impact it?
- Which cities drive the most listings and revenue, and why?
- How are properties rated, and where are the weak points in guest satisfaction?
- How trustworthy is the platform (host verification), and how often do guests leave reviews?

---

## 🗂️ Dataset

| Table | Rows | Description |
|---|---|---|
| **Listings** | 279,712 | Property-level data — host info, room type, city, pricing, ratings sub-scores |
| **Reviews** | 5,373,143 | Individual guest reviews, linked to listings via `listing_id` |

**Source:** Raw CSV files, imported and modeled in Power BI (star-schema style relationship between Listings and Reviews).

---

## 🧹 Data Preparation (Power Query)

- Built custom date-based columns from the reviews' date field:
  - **Month Number** — numeric month value used purely for correct chronological sorting of visuals
  - **Review Month** — readable month name (Jan, Feb, …) displayed on the axis, sorted by Month Number
- Established a relationship between the Listings and Reviews tables (on `listing_id`) so filters and slicers cross-highlight both tables throughout the report

---

## 🧮 DAX Measures

A range of custom DAX measures were built to power the KPIs, Pareto/cumulative-%, and rating breakdowns throughout the report.

### Listings table
| Measure | Purpose |
|---|---|
| `Total Listing` | Count of total listings — feeds the KPI card and the "Market Share by City" chart |
| `Avg Rating` | Average overall guest rating per city |
| `Avg Measure` | Average price, used in the room-type price comparison chart |
| `City Rank` | Ranks cities by listing volume, used to sort the Pareto chart |
| `Cumulative %` / `Cumulative Listings` | Running total and running % of listings by city rank, used for the Pareto/cumulative-% line |
| `Superhost Listings` | Count of listings hosted by a Superhost, used for the stacked Superhost vs. No Superhost split |
| `Entire Place`, `Private Room`, `Shared Room` | Count/avg price by `room_type`, feeding the New Listings trend and price comparison |
| `Accuracy`, `Cleanliness`, `Communication`, `Value` | Average of the respective `review_scores_*` columns per city — the rating sub-metric measures shown in the Detailed Rating table |
| `Verified_Profile`, `Verified_Profile %` | Count/% of hosts who are identity-verified **and** have a profile photo |
| `Verified_NoProfile`, `Verified_NoProfile %` | Count/% of hosts who are identity-verified but have **no** profile photo |
| `NotVerified_Profile`, `NotVerified_Profile %` | Count/% of hosts who are **not** identity-verified but do have a profile photo |
| `NotVerified_NoProfile`, `NotVerified_NoProfile %` | Count/% of hosts with neither verification nor a profile photo |

### Reviews table
| Measure | Purpose |
|---|---|
| `Total Reviews` | Total review count — feeds the KPI card |
| `Total Reviewers` | Distinct count of reviewers |
| `Reviews per Reviewer` | Average number of reviews left per reviewer |
| `Show in Review Frequency` | Buckets reviewers into review-count groups (1, 2, 3, 4, 5, 6, and outlier groups) for the Review Frequency chart |
| `Reviewers` | Count of reviewers within each frequency bucket |
| `Cumulative % Review Frequency` / `Cumulative Reviewers` | Running % and running total feeding the cumulative-% line on the Review Frequency Pareto chart |
| `% of Monthly Reviews` | Each city's share of total reviews within a given month — the core measure driving the Ribbon Chart |

---

## 📊 Report Pages

### 1️⃣ Overview
![Overview Page](assets/overview.png)

**Visuals:**
- **KPI Cards (5):** `Listings` 279,712 · `Cities` 10 · `Hosts` 182,024 · `Properties` 144 · `Reviews` 5.37M — built with Card visuals driven by `Total Listing`, a distinct count of `city`, a distinct count of `host_id`, a distinct count of `property_type`, and `Total Reviews`.
- **"New Listings" — multi-line trend chart (2008–2020):** plots `Total Listing`, `Entire Place`, `Hotel Room`, `Private Room`, and `Shared Room` over time on a Year axis. A shaded background region and text annotations mark out Airbnb's lifecycle stages — **Introduction → Growth → Maturity → Decline → Reinvention → COVID-19** — with callouts for the "Take off point," "Peak Point," "Increase of hotel rooms," and "Pre-COVID New Listings."

**Key finding:** New listings peaked in 2015. Growth slowed in 2016–2017 due to tighter local regulations, even as Airbnb turned profitable in that period. A renewed growth phase from 2018 was cut short by the COVID-19 pandemic in 2019–2020.

### 2️⃣ Ratings
![Ratings Page](assets/ratings.png)

**Visuals:**
- **"Market Share by City" — combo (Pareto) chart:** a stacked column chart of `Total Listing` per city (split into Superhost vs. No Superhost using `Superhost Listings`), combined with a `Cumulative %` line to show how quickly the top cities account for total market share.
- **Room-type price comparison — horizontal bar chart:** compares average nightly price (`Avg Measure`) across Hotel Room, Entire Place, Private Room, and Shared Room, with Entire Place highlighted since it's the direct Airbnb-vs-hotel comparison point.
- **Bookmark-driven Rating toggle:** two buttons — a magnifying-glass icon labeled **"Detailed Rating"** and a star icon labeled **"Overall Rating"** — each linked to its own **Power BI Bookmark**. Clicking a button applies that bookmark, which swaps the visual shown directly below (and updates the accompanying finding text) without navigating away from the page:
  - **Overall Rating bookmark:** shows a sorted column chart of `Avg Rating` by city (ascending, from Hong Kong at 89.7 up to Mexico City at 94.8), with data labels.
  - **Detailed Rating bookmark:** swaps in a table visual broken out by city with `Accuracy`, `Cleanliness`, `Communication`, `Location`, and `Value`, styled with color-scale conditional formatting per column so weak spots stand out at a glance.
  - Each bookmark was set to capture only the **data** state (which visual is visible) so the rest of the page's filters stay untouched when toggling.

**Key findings:**
- Paris, New York, and Sydney together account for almost half of all listings and 48% of total reviews. Paris leads on both — likely driven by hotel room prices running roughly double Airbnb's average nightly rate.
- Mexico City and Rio de Janeiro are the overall best-rated cities; Hong Kong and Istanbul rank lowest.
- Cleanliness and Value-for-money are the two rating categories that consistently score the lowest across cities.

### 3️⃣ Reviews
![Reviews Page](assets/reviews.png)

**Visuals:**
- **"Review Frequency" — combo (Pareto) chart:** a column chart of `Reviewers` bucketed by how many reviews they've written (`Show in Review Frequency`: 1, 2, 3, 4, 5, 6, 96, 283), paired with a `Cumulative % Review Frequency` line.
- **Ribbon Chart — monthly review share by city:** a native Power BI **Ribbon Chart**, using `% of Monthly Reviews` across the 12 months (`Review Month`, sorted by `Month Number`) for Mexico City, New York, Paris, Rome, and Sydney. The ribbon layout makes each city's month-to-month rank change visually obvious as the flowing bands cross over one another.
- **Host "Trust Shield" visual:** a shield-shaped graphic overlaid with four circular KPI values, split into two groups — **Identify Not Verified** (`NotVerified_NoProfile %` = 0.3%, `NotVerified_Profile %` = 32.6%) and **Identify Verified** (`Verified_NoProfile %` = 0.1%, `Verified_Profile %` = 66.9%) — giving an at-a-glance read on host trustworthiness.

**Key findings:**
- The vast majority of guests (86.5%) leave only a single review, and 98.8% leave three or fewer. One outlier reviewer left 283 reviews — including two on the same day for two different Bangkok listings — flagged as a likely data quality issue.
- Paris and Rome dominate review share from April to August, reflecting peak European summer travel. New York saw an increase in November and December during the holiday season.
- Over two-thirds of hosts are fully verified, and nearly all hosts provide at least one trust signal (verification or profile photo), keeping fully anonymous/unverified profiles to a minimum.

---

## 🛠️ Tools & Techniques Used

- **Power BI Desktop** — report design and data modeling
- **Power Query (M)** — data cleaning, transformation, and date-column engineering (Month Number, Review Month)
- **DAX** — custom measures for KPIs, Pareto/cumulative-% logic, rating breakdowns, and host trust segmentation
- **Bookmarks & Buttons** — interactive Overall Rating / Detailed Rating view-switching on the Ratings page
- **Ribbon Chart** — native Power BI visual used to show monthly rank changes in review share by city
- **Conditional formatting** — color-scale heatmap styling on the Detailed Rating table

---

## 📁 Repository Structure

```
├── assets/
│   ├── overview.png
│   ├── ratings.png
│   └── reviews.png
├── Global Airbnb Dashboard.pbix
└── README.md
```

---

## 🚀 Future Improvements

- Add a price-forecasting or demand-seasonality model
- Investigate and clean the flagged data-quality outlier (283-review reviewer)
- Expand city coverage beyond the current 10 markets

---

## 📬 Contact

**Aniket Panpatil**
Feel free to connect or reach out with feedback!
