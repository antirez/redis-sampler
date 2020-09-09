Redis Sampler README
====================

Redis sampler is an utility to check the composition of your Redis dataset.

```
Usage: redis-sampler.rb <host> <port> <sample_size>
    -u, --user=user                  The user to connect to the DB.
    -p, --password=password          The password to connect to the DB.
    -d, --db=dbnum                   The DB is the database to test. Defaults to 0.
    -h, --help                       Prints this help
```

The host and port arguments are the ones of your Redis instance.
By default Redis uses database 0 unless you
are writing against a different DB.

The sample size is the number of elements to check using RANDOMKEY.
For large datasets a sample size of 100000 or more is recommended.

To understand how the program works you can try a few runs setting the
sampling size to just 1000, for fast execution.

It is highly recommended to run the program via loopback interface or fast
LAN, otherwise the execution time will be pretty high.

Example Output
==============
```
Sampling localhost:6379 DB:4 with 1000000 RANDOMKEYS

TYPES
=====
 zset: 873268 (87.33%)    string: 124995 (12.50%)  set: 1022 (0.10%)
 hash: 576 (0.06%)        list: 139 (0.01%)

STRINGS, SIZE OF VALUES
=======================
 6: 61222 (48.98%)        7: 17056 (13.65%)        13: 8274 (6.62%)
 15: 7991 (6.39%)         5: 4629 (3.70%)          31: 3263 (2.61%)
 20: 2670 (2.14%)         2: 2518 (2.01%)          27: 1675 (1.34%)
 42: 1270 (1.02%)         159: 893 (0.71%)         1: 705 (0.56%)
 47: 641 (0.51%)          34: 594 (0.48%)          41: 521 (0.42%)
 38: 493 (0.39%)          28: 413 (0.33%)          22: 406 (0.32%)
 139: 351 (0.28%)         29: 343 (0.27%)          83: 337 (0.27%)
(suppressed 172 items with perc < 0.5% for a total of 6.98%)
 Average: 15.97 Standard Deviation: 26.52
 Min: 0 Max: 1123

Powers of two distribution: (NOTE <= p means: p/2 < x <= p)
 <= 8: 82913 (66.33%)     <= 16: 16789 (13.43%)    <= 32: 9571 (7.66%)
 <= 64: 6232 (4.99%)      <= 128: 3333 (2.67%)     <= 256: 2682 (2.15%)
 <= 2: 2518 (2.01%)       <= 1: 740 (0.59%)        <= 4: 199 (0.16%)
 <= 512: 14 (0.01%)       <= 1024: 3 (0.00%)       <= 2048: 1 (0.00%)

LISTS, NUMBER OF ELEMENTS
=========================
 2: 28 (20.14%)           5: 18 (12.95%)           9: 10 (7.19%)
 8: 9 (6.47%)             11: 9 (6.47%)            13: 7 (5.04%)
 12: 7 (5.04%)            14: 6 (4.32%)            15: 6 (4.32%)
 4: 4 (2.88%)             16: 4 (2.88%)            21: 4 (2.88%)
 27: 3 (2.16%)            7: 3 (2.16%)             10: 3 (2.16%)
 19: 2 (1.44%)            1: 2 (1.44%)             25: 2 (1.44%)
 41: 1 (0.72%)            3: 1 (0.72%)             17: 1 (0.72%)
(suppressed 9 items with perc < 0.5% for a total of 6.47%)
 Average: 10.58 Standard Deviation: 8.58
 Min: 1 Max: 42

Powers of two distribution: (NOTE <= p means: p/2 < x <= p)
 <= 16: 52 (37.41%)       <= 8: 30 (21.58%)        <= 2: 28 (20.14%)
 <= 32: 17 (12.23%)       <= 64: 5 (3.60%)         <= 4: 5 (3.60%)
 <= 1: 2 (1.44%)

LISTS, SIZE OF ELEMENTS
=======================
 7: 106 (76.26%)          6: 33 (23.74%)
 Average: 6.76 Standard Deviation: 0.43
 Min: 6 Max: 7

Powers of two distribution: (NOTE <= p means: p/2 < x <= p)
 <= 8: 139 (100.00%)

SETS, NUMBER OF ELEMENTS
========================
 1: 216361 (24.78%)       2: 106871 (12.24%)       3: 67648 (7.75%)
 4: 48207 (5.52%)         5: 36085 (4.13%)         6: 29597 (3.39%)
 7: 23765 (2.72%)         8: 22549 (2.58%)         9: 20143 (2.31%)
 10: 18069 (2.07%)        11: 16387 (1.88%)        12: 15009 (1.72%)
 13: 13869 (1.59%)        14: 12683 (1.45%)        15: 12319 (1.41%)
 16: 10794 (1.24%)        17: 10068 (1.15%)        18: 8925 (1.02%)
 19: 8007 (0.92%)         20: 7618 (0.87%)         22: 7240 (0.83%)
 21: 7055 (0.81%)         23: 5973 (0.68%)         24: 5771 (0.66%)
 25: 4934 (0.57%)
(suppressed 2061 items with perc < 0.5% for a total of 15.72%)
 Average: 1.24 Standard Deviation: 2.34
 Min: 1 Max: 62

Powers of two distribution: (NOTE <= p means: p/2 < x <= p)
 <= 1: 975 (95.40%)       <= 2: 21 (2.05%)         <= 8: 10 (0.98%)
 <= 4: 9 (0.88%)          <= 16: 5 (0.49%)         <= 32: 1 (0.10%)
 <= 64: 1 (0.10%)

SETS, SIZE OF ELEMENTS
======================
 19: 871 (85.23%)         3: 66 (6.46%)            4: 65 (6.36%)
 5: 11 (1.08%)            2: 9 (0.88%)
 Average: 16.71 Standard Deviation: 5.50
 Min: 2 Max: 19

Powers of two distribution: (NOTE <= p means: p/2 < x <= p)
 <= 32: 871 (85.23%)      <= 4: 131 (12.82%)       <= 8: 11 (1.08%)
 <= 2: 9 (0.88%)

SORTED SETS, NUMBER OF ELEMENTS
===============================
 1: 216361 (24.78%)       2: 106871 (12.24%)       3: 67648 (7.75%)
 4: 48207 (5.52%)         5: 36085 (4.13%)         6: 29597 (3.39%)
 7: 23765 (2.72%)         8: 22549 (2.58%)         9: 20143 (2.31%)
 10: 18069 (2.07%)        11: 16387 (1.88%)        12: 15009 (1.72%)
 13: 13869 (1.59%)        14: 12683 (1.45%)        15: 12319 (1.41%)
 16: 10794 (1.24%)        17: 10068 (1.15%)        18: 8925 (1.02%)
 19: 8007 (0.92%)         20: 7618 (0.87%)         22: 7240 (0.83%)
 21: 7055 (0.81%)         23: 5973 (0.68%)         24: 5771 (0.66%)
 25: 4934 (0.57%)
(suppressed 2061 items with perc < 0.5% for a total of 15.72%)
 Average: 25.47 Standard Deviation: 110.64
 Min: 1 Max: 7018

Powers of two distribution: (NOTE <= p means: p/2 < x <= p)
 <= 1: 216361 (24.78%)    <= 16: 119273 (13.66%)   <= 4: 115855 (13.27%)
 <= 8: 111996 (12.82%)    <= 2: 106871 (12.24%)    <= 32: 92814 (10.63%)
 <= 64: 52715 (6.04%)     <= 128: 29286 (3.35%)    <= 256: 13988 (1.60%)
 <= 512: 7098 (0.81%)     <= 1024: 4762 (0.55%)    <= 2048: 1840 (0.21%)
 <= 4096: 393 (0.05%)     <= 8192: 16 (0.00%)

SORTED SETS, SIZE OF ELEMENTS
=============================
 6: 710230 (81.33%)       5: 75292 (8.62%)         4: 68661 (7.86%)
 3: 17136 (1.96%)         2: 1412 (0.16%)          9: 253 (0.03%)
 1: 76 (0.01%)            8: 74 (0.01%)            7: 39 (0.00%)
 21: 6 (0.00%)            30: 6 (0.00%)            20: 6 (0.00%)
 23: 6 (0.00%)            26: 5 (0.00%)            34: 5 (0.00%)
 24: 4 (0.00%)            27: 4 (0.00%)            18: 4 (0.00%)
 15: 4 (0.00%)            38: 3 (0.00%)            43: 3 (0.00%)
(suppressed 24 items with perc < 0.5% for a total of 0.00%)
 Average: 5.69 Standard Deviation: 0.77
 Min: 1 Max: 63

Powers of two distribution: (NOTE <= p means: p/2 < x <= p)
 <= 8: 785635 (89.96%)    <= 4: 85797 (9.82%)      <= 2: 1412 (0.16%)
 <= 16: 262 (0.03%)       <= 1: 76 (0.01%)         <= 32: 58 (0.01%)
 <= 64: 28 (0.00%)

HASHES, NUMBER OF FIELDS
========================
 1: 301 (52.26%)          12: 177 (30.73%)         11: 95 (16.49%)
 13: 2 (0.35%)            14: 1 (0.17%)
 Average: 6.09 Standard Deviation: 5.34
 Min: 1 Max: 14

Powers of two distribution: (NOTE <= p means: p/2 < x <= p)
 <= 1: 301 (52.26%)       <= 16: 275 (47.74%)

HASHES, SIZE OF FIELDS
======================
 17: 301 (52.26%)         22: 179 (31.08%)         13: 95 (16.49%)
 12: 1 (0.17%)
 Average: 17.89 Standard Deviation: 3.11
 Min: 12 Max: 22

Powers of two distribution: (NOTE <= p means: p/2 < x <= p)
 <= 32: 480 (83.33%)      <= 16: 96 (16.67%)

HASHES, SIZE OF VALUES
======================
 13: 116 (20.14%)         3: 103 (17.88%)          410: 44 (7.64%)
 409: 38 (6.60%)          408: 27 (4.69%)          14: 22 (3.82%)
 407: 17 (2.95%)          395: 12 (2.08%)          406: 12 (2.08%)
 392: 11 (1.91%)          396: 11 (1.91%)          393: 11 (1.91%)
 4: 10 (1.74%)            12: 10 (1.74%)           411: 9 (1.56%)
 5: 7 (1.22%)             376: 7 (1.22%)           405: 6 (1.04%)
 349: 5 (0.87%)           347: 5 (0.87%)           359: 5 (0.87%)
(suppressed 43 items with perc < 0.5% for a total of 15.28%)
 Average: 207.90 Standard Deviation: 193.12
 Min: 1 Max: 416

Powers of two distribution: (NOTE <= p means: p/2 < x <= p)
 <= 512: 298 (51.74%)     <= 16: 151 (26.22%)      <= 4: 113 (19.62%)
 <= 8: 10 (1.74%)         <= 2: 3 (0.52%)          <= 1: 1 (0.17%)

```
