## 📈 Results

### Key Metric
* **Transaction Success Rate:** **65.11 %**

### Top 5 High-Risk Users (Potential Fraudsters)

| User ID | Tx Count | Avg Tx (USD) | Max Tx (USD) | Std Dev (USD) |
|--------|---------:|------------:|------------:|-------------:|
| efedf9d5-ab17-44d9-8caf-830e822a7876 | **664** | **1,388,600.11** | **159,877,889.27** | **14,550,105.36** |
| 3c1aa14d-818a-474f-847f-3d24907dd1c7 | 78 | 711,479.04 | 8,321,003.51 | 2,117,797.12 |
| 6b0490ff-c8d9-4aec-8e96-9623f7d9d556 | 54 | 1,824,018.61 | 4,377,632.37 | 1,712,291.58 |
| c521f3e0-9b2b-4ad3-96be-7dca3d86cd50 | 286 | 479,009.53 | 4,368,512.30 |   809,945.25 |
| 68b04d44-f1c9-46f1-8807-2193b4eb31d5 | 390 | 81,390.03  | 2,392,288.51 |   374,442.36 |

These five user IDs surfaced as the **highest-risk accounts** because of their exceptionally large transaction sizes—classic indicators of potential fraud.

### Interpretation
* **High-Value Anomalies:** Transactions exceeding \$10,000 were key in identifying these users.
* **Explainability:** Each risk score is backed by rule-based flags (high-value, first-time card payment, velocity bursts, and country mismatch).

Use the provided SQL views (`report_top_users_excl_known`, `report_high_value_tx`, etc.) to reproduce or refresh these results as new data arrives.

