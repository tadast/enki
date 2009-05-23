# workaround for the case when Rubaidh::GoogleAnalytics is loaded,
# but tracker_id is not specified.
# without this workaround it will produce Rubaidh::GoogleAnalyticsConfigurationError
if defined?Rubaidh && defined?Rubaidh::GoogleAnalytics && !Rubaidh::GoogleAnalytics.tracker_id
  Rubaidh::GoogleAnalytics.tracker_id = 'UA-CHANGE-ME'
end
