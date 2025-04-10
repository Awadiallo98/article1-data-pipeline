{% macro parse_french_datetime(date_col) %}
    SAFE.PARSE_DATETIME(
        '%e %B, %Y, %H:%M',
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
