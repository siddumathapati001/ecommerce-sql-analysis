# SQL Business Analysis – Insights

## Data Validation Summary

- Orders and customers show a clean relationship with no orphan records.
- Each order has ~1 item on average, indicating mostly single-item purchases.
- Payments often have multiple records per order, confirming installment behavior.
- Reviews exist only for a subset of orders, so review-based insights are limited.
- Some product categories are unmapped, handled using LEFT JOINs in analysis.

## Core Business Metrics

- The dataset spans from 04-09-2016 to 17-10-2018, covers multiple years, providing sufficient data to analyze long-term trends in revenue and customer behavior.
- The platform serves a large customer base with a high volume of orders, indicating significant marketplace activity.
- Average order value indicates relatively small basket sizes.
- Average Order Value for delivered orders (159.85) is very close to the average revenue per order based on payments (160.99), indicating that most payments correspond to successfully delivered orders.
- Revenue contribution is highest from delivered orders, while cancelled and unavailable orders contribute marginal revenue, highlighting limited revenue leakage.
- Monthly revenue shows clear fluctuations over time, suggesting seasonality and periods of higher customer demand.
- Customer acquisition follows a similar monthly pattern as revenue, indicating that revenue growth is largely driven by new customer inflow rather than repeat purchases.
- Payment installment analysis shows that customers frequently use multiple installments, reflecting preference for deferred payment options.
- Average orders per unique customer is close to one, indicating low repeat purchase behavior and potential opportunity to improve customer retention.

- The business primarily operate on sinle-item orders, which limits Average Order Value growth.
- Installment-heavy payments suggest customers are price sensitive.
- Low repeat ordering behavior indicates growth is acquisition-driven, not retention-driven.

## Customer Behavior Analysis

- The customer base is overwhelmingly dominated by one-time buyers, with nearly 97% of customers placing only a single order, indicating extremely low repeat purchase behavior.
- One-time customers contribute approximately 94% of total revenue, showing that the business revenue model is heavily acquisition-driven rather than retention-driven.
- Repeat customers form a very small fraction of the customer base, and their overall revenue contribution is limited due to their low volume.
- The average revenue generated per customer is ₹166.59, which is relatively low and aligned with the dominance of single-order customers.
- Monthly revenue trends closely track the number of active purchasing customers, indicating that revenue growth is primarily driven by fluctuations in customer volume rather than increased spending or repeat purchases.
- The presence of a small number of customers placing up to 17 orders suggests that a niche segment with high engagement exists, but it is not large enough to materially influence overall revenue.
- The analysis indicates that improving repeat purchase rates, even marginally, could significantly increase total revenue without requiring proportional growth in customer acquisition.

## Customer Cohort & Retention 

- Customer retention drops sharply after the first purchase, with average Month-1 retention at approximately 5%, indicating very weak conversion from first to second purchase.
- Retention declines further to below 0.5% by Month-2, and remains consistently under 0.3% beyond Month-3, showing that long-term customer engagement is extremely limited.
- Retention patterns are consistent across cohorts, suggesting that low repeat behavior is a structural issue rather than a seasonal or cohort-specific problem.
- While a few cohorts show higher Month-1 retention, the minimum retention drops as low as ~0.1%, indicating high variability but no sustained improvement over time.
- Overall, less than 1% of customers remain active beyond two months, making the business heavily dependent on continuous new customer acquisition for revenue growth.

## Revenue Leakage & Operational Risk 

- The majority of revenue comes from delivered orders (₹15.42M), but a noticeable amount of revenue (₹0.59M) is associated with non-delivered orders, indicating direct revenue exposure due to cancellations and fulfillment issues.
- Although non-delivered orders contribute a smaller share compared to delivered orders, ₹586K of revenue at risk is still material and can impact profitability at scale.
- Around 8% of delivered orders are delayed (7,834 delayed vs 88,644 on-time), showing that delivery delays are not rare and represent a recurring operational issue.
- Delivery delays have a strong negative impact on customer experience, with average review scores dropping sharply from 4.29 for on-time deliveries to 2.57 for delayed deliveries.
- Customer satisfaction is heavily skewed toward positive reviews, with 58% of orders receiving a 5-star rating, but a significant 14% of orders still receive the lowest rating (1 star), indicating pockets of poor customer experience.
- Lower review scores represent a meaningful risk, as dissatisfied customers contribute revenue today but increase the likelihood of churn, refunds, and negative word-of-mouth in the future.
- Seller-level analysis shows that operational risk is concentrated among a small group of sellers, where a few sellers have over 100–200 problematic orders despite similar total order volumes.
- This concentration suggests that targeted seller monitoring and intervention could significantly reduce delivery issues and revenue leakage without impacting the broader seller base.

## Seller Performance & Risk – Key Insights

- Seller revenue is highly concentrated, with a small group of sellers generating a disproportionately large share of total seller revenue.
- High revenue does not always indicate high quality, as some top-revenue sellers also show below-average review scores and elevated operational issues.
- Certain sellers generate significant revenue but also have meaningful revenue at risk due to non-delivered orders, indicating a trade-off between scale and reliability.
- Delivery delays are unevenly distributed across sellers, with some sellers delaying more than 20–30% of their delivered orders, pointing to seller-specific logistics issues rather than platform-wide problems.
- Seller risk scores reveal that a small subset of sellers have more than 25–35% of their orders classified as problematic, making them a major source of operational and revenue risk.
- The difference between delay rate and risk score highlights that some sellers are slow but consistent, while others fail more broadly through cancellations and unavailability.
- Overall operational risk is concentrated among a limited number of sellers, suggesting that targeted seller monitoring and corrective actions could significantly reduce delivery issues and revenue leakage without impacting the majority of sellers.


