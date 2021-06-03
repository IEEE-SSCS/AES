#!/usr/bin/python

#TODO: Make it go deeper than 1 level
import argparse
import os

parser = argparse.ArgumentParser()

if __name__ == "__main__":

    args = parser.parse_args()

    # get the list of directories
    dirs = os.listdir()

    # make a list to save file paths
    file_names = []
    
    # print all directory names
    for dir_item in dirs:
        if ("." in dir_item) or (dir_item.lower() == "images") or (dir_item.lower() == "docs"): continue    #skip files
        
        if os.path.isdir(dir_item):
            level1 = os.listdir(dir_item + "/")
            for level1_item in level1:
                if os.path.isdir(level1_item) == False:
                    item_path = dir_item + "/" + level1_item +"\n"
                    if "pkg" in item_path: file_names.insert(0, item_path)
                    else: file_names.append(item_path)
                
            with open(dir_item + ".f", "w") as f_handle:
                f_handle.writelines(file_names)
                file_names = []

