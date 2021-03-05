#!/bin/bash

# run this file from vio pipeline: rdo_vm_ip

changed_list=`find /usr/lib/python2.7/site-packages/neutron /usr/lib/python2.7/site-packages/neutron_lbaas /usr/lib/python2.7/site-packages/neutronclient -name *.origin`

timestamp=`date +%s`
target_dir=/tmp/patches-$timestamp
mkdir -p $target_dir

for n in $changed_list; do
    echo $n
    changed_file="`echo $n | sed 's/.origin$//'`"
    file_dir=$target_dir/"`dirname $changed_file`"
    mkdir -p $file_dir
    cp $changed_file $file_dir
done

find $target_dir -type f