##
# @file fastqc_parser.py
# @brief Script for parsing FastQC results. 
# @author Ankit Srivastava <asrivast@gatech.edu>
# @version 1.0
# @date 2017-02-17
#
# This script is used for generating a single file tabulating the results from
# a directory of FastQC files. It takes a directory containing '*_fastqc.html'
# as input and outputs a file named 'results.txt' which can be imported in
# any spreadsheet software.
# 
# Usage:
# python fastqc_parser.py <path to directory>

from HTMLParser import HTMLParser
from collections import defaultdict
import glob
import os
import sys

allFields = (
             'Basic Statistics', 'Per base sequence quality', 'Per tile sequence quality',
             'Per sequence quality scores', 'Per base sequence content', 'Per sequence GC content',
             'Per base N content', 'Sequence Length Distribution', 'Sequence Duplication Levels',
             'Overrepresented sequences', 'Adapter Content', 'Kmer Content',
            )


class MyHTMLParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.__prevAltText = None
        self.__fieldsMap = dict.fromkeys(allFields)

    def handle_starttag(self, tag, attrs):
        if tag == 'img':
            for attr, value in attrs:
                if attr == 'alt':
                    self.__prevAltText = value

    def handle_data(self, data):
        if data in self.__fieldsMap:
            self.__fieldsMap[data] = self.__prevAltText 

    def getFieldsMap(self):
        return self.__fieldsMap

try:
    topDir = sys.argv[1]
except IndexError:
    raise RuntimeError, 'Address of the directory containing FastQC files is required as an argument.'

fileList = []
fieldValues = defaultdict(list)

for fileName in glob.glob(os.path.join(topDir, '*_fastqc.html')):
    fileList.append(os.path.basename(fileName).replace('_fastqc.html', ''))
    with open(fileName, 'rb') as f:
        data = f.read()
        parser = MyHTMLParser()
        parser.feed(data)
        thisMap = parser.getFieldsMap() 
        for field, value in thisMap.iteritems():
            fieldValues[field].append(value)

with open('results.txt', 'wb') as o:
    o.write('Fields\t' + '\t'.join(fileList) + '\n')
    for field in allFields:
        o.write(field + '\t' + '\t'.join(fieldValues[field]) + '\n')
