import sys
import re

comments = []
content = ""
documents = []

def getComments(text):
    for comment in re.findall(r'\*\*(.*?)\)\ \{', text, re.S):
        yield re.sub('\n+', '|', re.sub(r'[ *]+', ' ', comment).strip())

def processLine(inputLine):
    return list(filter(None, [line.strip() for line in inputLine.split("|")]))

def buildDocument(comment):
    document = {
      "name": "",
      "invocation": "",
      "desc": "",
      "params": [],
      "return": ""
    }
    for index in range(len(comment)):
        key = comment[index].split()[0];
        if key == "@param":
            document["params"].append(comment[index][7:].split(" ", 1))
        elif key == "@return":
            document["return"] = comment[index][8:]
        elif key == "/":
            continue
        elif index == len(comment) - 1:
            declaration = comment[index].split("(")
            document["name"] = declaration[0].split()[-1]
            document["invocation"] = "(" + declaration[-1] + ")"
            args = [arg.strip() for arg in declaration[-1].split(",")]
            for index, value in enumerate(document['params']):
                try:
                    document['params'][index][0] = args[index]
                except IndexError:
                    print("Parameter mismatch for method '" + document['name'] + "':")
                    print("Documented params: " + str(document['params']))
                    print("Arguments: " + str(args))
                    exit()
        else:
            document["desc"] += comment[index] + " "
    document["desc"] = document["desc"].strip()
    print(document)

def main():
    if (len(sys.argv) > 1):
        with open(sys.argv[1], 'r') as file:
            content = file.read()

        comments = [processLine(line) for line in list(getComments(content))]

        for comment in comments:
            buildDocument(comment)
    else:
        print("No path given")

if __name__ == '__main__':
    main()