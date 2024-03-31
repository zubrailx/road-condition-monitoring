import json

if __name__ == "__main__":
    fileName = input('Enter json list file: ')
    file = open(fileName, 'r')

    data = []

    for line in file.readlines():
        js = json.loads(line)
        data.append(js)

    print(data)

