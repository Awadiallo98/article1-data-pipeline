{% macro parse_french_date(date_col) %}
    SAFE.PARSE_DATE(
        '%e %B, %Y',
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(
                                            REPLACE(
                                                REPLACE(
                                                    REPLACE(LOWER({{ date_col }}),
                                                    'janvier', 'january'),
                                                'février', 'february'),
                                            'mars', 'march'),
                                        'avril', 'april'),
                                    'mai', 'may'),
                                'juin', 'june'),
                            'juillet', 'july'),
                        'août', 'august'),
                    'septembre', 'september'),
                'octobre', 'october'),
            'novembre', 'november'),
        'décembre', 'december')
    )
{% endmacro %}
