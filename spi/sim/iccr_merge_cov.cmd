set merge -union
merge cov_work/scope/* -output merge_dir
load_test merge_dir
report_html *
exit
