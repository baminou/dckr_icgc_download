#!/usr/bin/env python

from icgconnect import collab, aws
import os
import argparse
import subprocess

def main():

    # Parsing the command line arguments
    parser = argparse.ArgumentParser(description='Download a file from Collaboratory')
    parser.add_argument('-id', '--object-id', dest='object_id', help="Object ID on Collaboratory", required=True)
    parser.add_argument('-o', '--output', dest='out_dir', help="Output directory", required=True)
    parser.add_argument('--skip-validation', dest='skip_validation', help="Skip validation", action='store_true')

    results = parser.parse_args()

    try:
        FNULL = open(os.devnull, 'w')
        subprocess.call(['icgc-storage-client'], stdout=FNULL, stderr=subprocess.STDOUT)
    except OSError as e:
        if e.errno == os.errno.ENOENT:
            print "Error: icgc-storage-client in not installed in the path"
            exit(1)

    collab.download(results.object_id, 'icgc-storage-client',results.out_dir, results.skip_validation)

if __name__ == '__main__':
    main()
