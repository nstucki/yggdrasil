---
name: mimir-data-analysis
description: Analyze logs, metrics, telemetry, and structured data to identify patterns and answer questions.
---

# Data Analysis

## Purpose

Analyze logs, metrics, telemetry, and structured data to identify patterns, diagnose issues, and extract insights that inform decisions.

## When to Use

- When investigating performance issues or system behavior.
- When analyzing error logs or crash reports to find root causes.
- When extracting usage patterns or trends from telemetry data.
- When data-driven answers are needed rather than speculation.

## Workflow

1. **Understand the question.**
   - What specific question or hypothesis is being investigated?
   - What data would provide the answer?
   - What is the expected baseline or normal behavior?

2. **Gather the data.**
   - Identify relevant data sources (log files, metrics endpoints, databases, analytics).
   - Collect a representative sample or time range.
   - Note any data quality issues or gaps.

3. **Analyze the data.**
   - Look for patterns, anomalies, correlations, and trends.
   - Aggregate and summarize where appropriate (counts, rates, distributions).
   - Compare against expected baselines or historical data.

4. **Draw conclusions.**
   - Determine what the data indicates and with what level of confidence.
   - Identify actionable insights or recommendations.
   - Note any caveats, limitations, or confounding factors.

5. **Report findings.**
   - Present the analysis clearly: what was found, how it was found, and what it means.
   - Include relevant visualizations or summaries where helpful.
   - Recommend next steps or further investigation if needed.

## Quality Criteria

- The analysis answers the original question or explains why it cannot be answered.
- Data sources and time ranges are documented.
- Conclusions are supported by data, not intuition.
- Limitations and uncertainties are disclosed.

## Anti-Patterns

- **Cherry-picking**: Selecting data that supports a desired conclusion while ignoring contrary data.
- **Over-interpretation**: Drawing strong conclusions from insufficient or noisy data.
- **Correlation as causation**: Assuming a relationship is causal without evidence.
- **Analysis paralysis**: Spending excessive time refining analysis instead of reporting actionable findings.
