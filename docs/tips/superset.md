# Superset

[Apache Superset](https://superset.apache.org/) is an easy-to-use data exploration and data visualization platform.

You can install it on your local and also you can use it as a service.

- [Installing Superset Locally Using Docker Compose](https://superset.apache.org/docs/installation/installing-superset-using-docker-compose)
- [Preset Cloud](https://preset.io/registration)

This doc demonstrates how you can use SuperSet to visualize the Mihari data.

## World Map

```sql
SELECT artifacts.data, artifacts.data_type, geolocations.country_code, artifacts.created_at FROM artifacts
LEFT OUTER JOIN geolocations ON geolocations.artifact_id  = artifacts.id
ORDER BY artifacts.created_at DESC
```

This query generates a result like the following:

![img](https://i.imgur.com/3nugPCV.png)

You can visualize the data with the following configuration:

- Visualization type: World Map
- Country column: `country_code`
- Metric: `count(data)`

![img](https://i.imgur.com/O7ZM3mu.png)
