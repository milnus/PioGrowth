# Read od_readings.csv file

    Code
      raw_pio_od_data_to_wide_frame(test_path("Data", "raw_pio_od_data_to_wide_frame",
        "Two_reactor_test_read.csv"))
    Output
      $pioreactor_OD_data_wide
                     hours od_reading.P01 od_reading.P08
      1  0.000000000 hours     0.03084427             NA
      2  0.004197621 hours             NA     0.01391040
      3  0.008418898 hours     0.03903061             NA
      4  0.012606564 hours             NA     0.01042361
      5  0.016834934 hours     0.03644281             NA
      6  0.021024167 hours             NA     0.01549249
      7  0.025252256 hours     0.03295821             NA
      8  0.029441651 hours             NA     0.01439069
      9  0.033670211 hours     0.02542879             NA
      10 0.037859038 hours             NA     0.01699642
      11 0.042087574 hours     0.03472532             NA
      12 0.046276628 hours             NA     0.01654550
      
      $raw_time
                     hours timestamp_localtime.P01 timestamp_localtime.P08
      1  0.000000000 hours     2024-02-12 12:00:59                    <NA>
      2  0.004197621 hours                    <NA>     2024-02-12 12:01:14
      3  0.008418898 hours     2024-02-12 12:01:30                    <NA>
      4  0.012606564 hours                    <NA>     2024-02-12 12:01:45
      5  0.016834934 hours     2024-02-12 12:02:00                    <NA>
      6  0.021024167 hours                    <NA>     2024-02-12 12:02:15
      7  0.025252256 hours     2024-02-12 12:02:30                    <NA>
      8  0.029441651 hours                    <NA>     2024-02-12 12:02:45
      9  0.033670211 hours     2024-02-12 12:03:00                    <NA>
      10 0.037859038 hours                    <NA>     2024-02-12 12:03:16
      11 0.042087574 hours     2024-02-12 12:03:31                    <NA>
      12 0.046276628 hours                    <NA>     2024-02-12 12:03:46
      
      $file_path
      [1] "Data/raw_pio_od_data_to_wide_frame/Two_reactor_test_read.csv"
      

