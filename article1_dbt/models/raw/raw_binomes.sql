{{ config(materialized='table', schema='raw') }}

SELECT
  *
FROM {{ source('airbyte', 'binomes') }}
