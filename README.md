# Sales Pipeline Analysis
This project analyses 8,800+ SaaS sales opportunities to understand what drives uneven conversion and how revenue predictability can be improved.
The objective is to identify whether differences in performance are driven by product, market segment, or sales execution, and to determine which factors most impact conversion and forecast reliability.

## Key question

What factors are driving variation in pipeline conversion, and how can the business improve revenue predictability?

## Dataset
The analysis is based on three core tables representing accounts, opportunities, and sales structure:

**accounts**
- Contains company-level information including sector, employee size, year established, and location

**sales_pipeline**
- Contains opportunity-level data including sales agent, product, associated account, deal stage, engage date, close date, and close value
- Note: opportunities in early stages (Prospecting and Engaging) may have missing account information

**sales_teams**
- Contains organisational data linking each sales agent to their manager and regional office

These tables were joined to enable analysis across opportunity, account, and organisational dimensions.

## Analytical Approach / Methodology
### 1. Define the key drivers of revenue predictability

To assess revenue predictability, the analysis focused on three core performance measures:
- win rate
- time to close
- average deal value

### 2. Establish baseline performance

Overall averages were calculated first to create a benchmark for comparison across the business.

### 3. Test variation across key dimensions

Each metric was then analysed across different dimensions to identify where performance varied most. These included:
- sales agent
- sales manager
- regional office
- product
- sector
- company size

The goal at this stage was to identify whether uneven performance was primarily driven by product mix, market segment, organisational structure, or individual execution.

### 4. Investigate likely explanations for variation

Where meaningful variation appeared, the analysis went one step further to test possible explanations. For example, if win rates differed significantly across sales agents, the next step was to assess whether those differences could be partially explained by opportunity mix, such as company size or deal value, rather than execution alone.

This approach was designed to move beyond simple descriptive reporting and toward a more decision-oriented understanding of what drives conversion and forecast reliability.

## Key Findings

The analysis found that variation in pipeline conversion is driven more by individual sales-agent performance than by product, sector, region, or manager-level differences.

Product and sector showed only limited variation in closed win rate, suggesting that neither product mix nor industry segment is a strong standalone explanation for uneven conversion. Regional office and manager-level results were also relatively tightly clustered.

Sales-agent performance showed the clearest spread in win rate, indicating that rep-level factors are a more meaningful source of variation. However, further analysis suggested that opportunity mix only partially explains this pattern. Company size showed more variation than product or sector, but rep-level exposure to different company segments did not fully account for the differences in win rate between agents.

To bring the analysis closer to commercial impact, win rate was combined with average deal value to create an expected revenue per opportunity metric. This produced a meaningfully different ranking from win rate alone, showing that conversion by itself is an incomplete measure of performance. Some agents closed a lower share of deals but still generated stronger expected value through larger opportunities.

Overall, the project suggests that improving revenue predictability requires a more rep-level view of performance, while also accounting for deal mix and value rather than relying on win rate alone.

### Limitations
Some early-stage opportunities had missing account information, which reduced coverage for analyses requiring account-level fields such as sector and company size. As a result, segment-based analysis was performed on the matched subset of closed deals.
The dataset also supports identification of patterns and associations, but not definitive causal conclusions. Differences in win rate may reflect a combination of execution, deal mix, and other factors not captured in the available tables.

### Recommendations
- Prioritise rep-level performance analysis rather than assuming product, sector, or region are the main drivers of conversion differences
- Evaluate sales performance using both conversion and deal value, rather than win rate alone
- Incorporate company size and other opportunity-mix factors into rep-level benchmarking
- Improve account data completeness for earlier-stage opportunities to support more reliable segmentation and reporting
