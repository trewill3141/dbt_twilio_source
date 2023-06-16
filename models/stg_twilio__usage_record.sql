with base as (

    select * 
    from {{ ref('stg_twilio__usage_record_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_twilio__usage_record_tmp')),
                staging_columns=get_usage_record_columns()
            )
        }}
    from base
),

final as (
    
    select 
        _fivetran_synced,
        account_id,
        as_of,
        category,
        count,
        count_unit,
        description,
        end_date,
        cast(price as {{ dbt.type_float() }}) as price,
        price_unit,
        start_date,
        usage,
        usage_unit
    from fields
)

select *
from final
