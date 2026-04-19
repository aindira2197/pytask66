import os
import gzip
import shutil
from zipfile import ZipFile

def compress_file(input_filename, output_filename):
    with open(input_filename, 'rb') as f_in:
        with gzip.open(output_filename, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)

def decompress_file(input_filename, output_filename):
    with gzip.open(input_filename, 'rb') as f_in:
        with open(output_filename, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)

def zip_file(input_filename, output_filename):
    with ZipFile(output_filename, 'w') as zip_file:
        zip_file.write(input_filename)

def unzip_file(input_filename, output_filename):
    with ZipFile(input_filename, 'r') as zip_file:
        zip_file.extractall(output_filename)

def main():
    while True:
        print("1. Compress file")
        print("2. Decompress file")
        print("3. Zip file")
        print("4. Unzip file")
        print("5. Exit")
        choice = input("Enter your choice: ")
        if choice == '1':
            input_filename = input("Enter input filename: ")
            output_filename = input("Enter output filename: ")
            compress_file(input_filename, output_filename)
        elif choice == '2':
            input_filename = input("Enter input filename: ")
            output_filename = input("Enter output filename: ")
            decompress_file(input_filename, output_filename)
        elif choice == '3':
            input_filename = input("Enter input filename: ")
            output_filename = input("Enter output filename: ")
            zip_file(input_filename, output_filename)
        elif choice == '4':
            input_filename = input("Enter input filename: ")
            output_filename = input("Enter output filename: ")
            unzip_file(input_filename, output_filename)
        elif choice == '5':
            break
        else:
            print("Invalid choice")

if __name__ == "__main__":
    main()