SELECT  profile_option_name,
        hierarchy_type
FROM    fnd_profile_options
WHERE   profile_option_name IN (
                                'APPS_WEB_AGENT',
                                'APPS_SERVLET_AGENT',
                                'APPS_JSP_AGENT',
                                'APPS_FRAMEWORK_AGENT',
                                'ICX_FORMS_LAUNCHER',
                                'ICX_DISCOVERER_LAUNCHER',
                                'ICX_DISCOVERER_VIEWER_LAUNCHER',
                                'HELP_WEB_AGENT',
                                'APPS_PORTAL',
                                'CZ_UIMGR_URL',
                                'ASO_CONFIGURATOR_URL',
                                'QP_PRICING_ENGINE_URL',
                                'TCF:HOST'
                               );
