# simple spline

    Code
      spline_growth_integration(input_od_data_list)
    Message
      Processing Reactor: P01
      Processing Reactor: P02
    Output
            Time  OD_values Reactor OD_values_log  Spline_OD Spline_growth_rate
      P01.1    1   2.718282     P01          0.01   2.745601                  1
      P01.2    2   7.389056     P01          1.01   7.463317                  1
      P01.3    3  20.085537     P01          2.01  20.287400                  1
      P01.4    4  54.598150     P01          3.01  55.146871                  1
      P01.5    5 148.413159     P01          4.01 149.904736                  1
      P02.1    1   2.718282     P02          0.01   2.745601                  1
      P02.2    2   7.389056     P02          1.01   7.463317                  1
      P02.3    3  20.085537     P02          2.01  20.287400                  1
      P02.4    4  54.598150     P02          3.01  55.146871                  1
      P02.5    5 148.413159     P02          4.01 149.904736                  1
            Spline_OD_log
      P01.1          0.01
      P01.2          1.01
      P01.3          2.01
      P01.4          3.01
      P01.5          4.01
      P02.1          0.01
      P02.2          1.01
      P02.3          2.01
      P02.4          3.01
      P02.5          4.01

# spline w. NA

    Code
      spline_growth_integration(input_od_data_list)
    Message
      Processing Reactor: P01
      Processing Reactor: P02
    Output
            Time  OD_values Reactor OD_values_log  Spline_OD Spline_growth_rate
      P01.2    2   7.389056     P01          0.01   7.463317                  1
      P01.3    3  20.085537     P01          1.01  20.287400                  1
      P01.4    4  54.598150     P01          2.01  55.146871                  1
      P01.5    5 148.413159     P01          3.01 149.904736                  1
      P02.2    2   7.389056     P02          0.01   7.463317                  1
      P02.3    3  20.085537     P02          1.01  20.287400                  1
      P02.4    4  54.598150     P02          2.01  55.146871                  1
      P02.5    5 148.413159     P02          3.01 149.904736                  1
            Spline_OD_log
      P01.2          0.01
      P01.3          1.01
      P01.4          2.01
      P01.5          3.01
      P02.2          0.01
      P02.3          1.01
      P02.4          2.01
      P02.5          3.01

# spline w. outlier

    Code
      spline_growth_integration(input_od_data_list)
    Message
      Processing Reactor: P01
      Processing Reactor: P02
    Output
            Time  OD_values Reactor OD_values_log  Spline_OD Spline_growth_rate
      P01.2    2   7.389056     P01          0.01   7.463317                  1
      P01.3    3  20.085537     P01          1.01  20.287400                  1
      P01.4    4  54.598150     P01          2.01  55.146871                  1
      P01.5    5 148.413159     P01          3.01 149.904736                  1
      P02.2    2   7.389056     P02          0.01   7.463317                  1
      P02.3    3  20.085537     P02          1.01  20.287400                  1
      P02.4    4  54.598150     P02          2.01  55.146871                  1
      P02.5    5 148.413159     P02          3.01 149.904736                  1
            Spline_OD_log
      P01.2          0.01
      P01.3          1.01
      P01.4          2.01
      P01.5          3.01
      P02.2          0.01
      P02.3          1.01
      P02.4          2.01
      P02.5          3.01

# spline w. outlier and NA

    Code
      spline_growth_integration(input_od_data_list)
    Message
      Processing Reactor: P01
      Processing Reactor: P02
    Output
             Time    OD_values Reactor OD_values_log    Spline_OD Spline_growth_rate
      P01.2     2     7.389056     P01          0.01     7.463317                  1
      P01.4     4    54.598150     P01          2.01    55.146871                  1
      P01.5     5   148.413159     P01          3.01   149.904736                  1
      P01.6     6   403.428793     P01          4.01   407.483320                  1
      P01.7     7  1096.633158     P01          5.01  1107.654505                  1
      P01.8     8  2980.957987     P01          6.01  3010.917113                  1
      P01.9     9  8103.083928     P01          7.01  8184.521276                  1
      P01.10   10 22026.465795     P01          8.01 22247.835459                  1
      P02.2     2     7.389056     P02          0.01     7.463317                  1
      P02.4     4    54.598150     P02          2.01    55.146871                  1
      P02.5     5   148.413159     P02          3.01   149.904736                  1
      P02.6     6   403.428793     P02          4.01   407.483320                  1
      P02.7     7  1096.633158     P02          5.01  1107.654505                  1
      P02.8     8  2980.957987     P02          6.01  3010.917113                  1
      P02.9     9  8103.083928     P02          7.01  8184.521276                  1
      P02.10   10 22026.465795     P02          8.01 22247.835459                  1
             Spline_OD_log
      P01.2           0.01
      P01.4           2.01
      P01.5           3.01
      P01.6           4.01
      P01.7           5.01
      P01.8           6.01
      P01.9           7.01
      P01.10          8.01
      P02.2           0.01
      P02.4           2.01
      P02.5           3.01
      P02.6           4.01
      P02.7           5.01
      P02.8           6.01
      P02.9           7.01
      P02.10          8.01

