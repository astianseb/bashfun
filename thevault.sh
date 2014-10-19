#!/bin/bash

# Script which is showing how to use sqlite and UUID's. Script takes a directory as a paramter,
# and makes a "coded" version on that directory in "the vault". Coding is simple, is just using UUID's
# to code directory and filenames. Mapping of file/directory -> UUID is kept in sqlite database.
#
# Usage: thevault.sh <directory>
#
# Copyright: astianseb


_directory=$1
DB_FILE="sg2.db"

if [ ! -e $DB_FILE ]
    then
        echo "...Database does not extist, creating one";
        sqlite3 $DB_FILE "CREATE TABLE data (id INTEGER PRIMARY KEY,dir TEXT, filename TEXT, dir_uuid TEXT, file_uuid TEXT)";
    else
        echo "...database $DB_FILE already exist!"
fi

if [ ! -e ./Vault ]
    then
        echo "Creating Vault"
        mkdir Vault
    else
        echo "Vault exist!"
fi

dir_uuid=$(cat /proc/sys/kernel/random/uuid)

if [ -n "`sqlite3 $DB_FILE "SELECT dir FROM data WHERE dir='$_directory'"`" ]
    then
        echo "Directory already in database!"
    else
        echo "adding..."
        mkdir ./Vault/$dir_uuid
        for i in `ls $_directory`;do
            file_uuid=$(cat /proc/sys/kernel/random/uuid);
            sqlite3 $DB_FILE "INSERT INTO data (dir,filename,dir_uuid,file_uuid) VALUES ('$_directory','$i','$dir_uuid','$file_uuid')";
            echo "File $i added to database $DB_FILE"
            tar -cjf ./Vault/$dir_uuid/$file_uuid.tar $_directory/$i
    done

fi


