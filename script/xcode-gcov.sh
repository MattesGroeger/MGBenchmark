#!/bin/bash
 
trim()
{
    trimmed=$1
    trimmed=${trimmed%% }
    trimmed=${trimmed## }
 
    echo $trimmed
}
xctoolVars=$(xctool -workspace MGBenchmark.xcworkspace -scheme MGBenchmarkTests -showBuildSettings | egrep '(BUILT_PRODUCTS_DIR)|(CURRENT_ARCH)|(OBJECT_FILE_DIR_normal)|(SRCROOT)|(OBJROOT)' |  egrep -v 'Pods')
while read line; do
	declare key=$(echo "${line}" | cut -d "=" -f1)
	declare value=$(echo "${line}" | cut -d "=" -f2)
	printf -v "`trim ${key}`" "`trim ${value}`"
done < <( echo "${xctoolVars}" )
 
declare gcov_dir="${OBJECT_FILE_DIR_normal}/${CURRENT_ARCH}"
echo $gcov_dir
