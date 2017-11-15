/*
SELECT drp.time_id,
       COUNT(DISTINCT e.user_id) AS weekly_active_users
  FROM benn.dimension_rollup_periods drp
  LEFT JOIN tutorial.yammer_events e
    ON e.occurred_at >= drp.pst_start
   AND e.occurred_at < drp.pst_end
   AND e.event_type = 'engagement'
   AND e.event_name = 'login'
 WHERE drp.period_id = 1007
   AND drp.time_id >= '2014-06-01'
   AND drp.time_id < '2014-09-01'
 GROUP BY 1
 ORDER BY 1
*/
SELECT drp.time_id,
       COUNT(DISTINCT e.user_id) AS weekly_active_users,
       COUNT(DISTINCT CASE WHEN e.device IN ('macbook pro','lenovo thinkpad','macbook air','dell inspiron notebook',
          'asus chromebook','dell inspiron desktop','acer aspire notebook','hp pavilion desktop','acer aspire desktop','mac mini')
          THEN e.user_id ELSE NULL END) AS computer,
       COUNT(DISTINCT CASE WHEN e.device IN ('iphone 5','samsung galaxy s4','nexus 5','iphone 5s','iphone 4s','nokia lumia 635',
       'htc one','samsung galaxy note','amazon fire phone') THEN e.user_id ELSE NULL END) AS phone,
        COUNT(DISTINCT CASE WHEN e.device IN ('ipad air','nexus 7','ipad mini','nexus 10','kindle fire','windows surface',
        'samsumg galaxy tablet') THEN e.user_id ELSE NULL END) AS tablet
  FROM benn.dimension_rollup_periods drp
  LEFT JOIN tutorial.yammer_events e
    ON e.occurred_at >= drp.pst_start
   AND e.occurred_at < drp.pst_end
   AND e.event_type = 'engagement'
   AND e.event_name = 'login'
 WHERE drp.period_id = 1007
   AND drp.time_id >= '2014-06-01'
   AND drp.time_id < '2014-09-01'
 GROUP BY 1
 ORDER BY 1
LIMIT 100