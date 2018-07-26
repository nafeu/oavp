import sys
import re

comments = []
content = ""
documents = []
kebabCompilerA = re.compile(r'(.)([A-Z][a-z]+)')
kebabCompilerB = re.compile('([a-z0-9])([A-Z])')

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
      "return": "",
      "references": [],
    }
    for index in range(len(comment)):
        key = comment[index].split()[0];
        if key == "@param":
            document["params"].append(comment[index][7:].split(" ", 1))
        elif key == "@return":
            document["return"] = comment[index][8:]
        elif key == "@see":
            document["references"].append(comment[index][4:].strip())
        elif key == "/" or key[0] == "@":
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
    documents.append(document)

def generateDocumentation(documents):
    print("Generative docs...")
    file = open("doc-export.md", "w+")
    file.write("## Contents\r\n")
    for document in documents:
        file.write("* <a href=\"#" + camelToKebab(document["name"]) +"\">" + document["name"] + "</a>\r\n")
    for document in documents:
        file.write("\r\n---\r\n\r\n")
        file.write("<a name=\"" + camelToKebab(document["name"]) + "\"/>\r\n")
        file.write("\r\n")
        file.write("| " + document["name"] + " | |\r\n")
        file.write("| :--- | :--- |\r\n")
        file.write("| Description | " + document["desc"] + " |\r\n")
        file.write("| Syntax | `" + document["name"] + document["invocation"] + "` |\r\n")
        file.write("| Parameters | ")
        for param in document["params"]:
            file.write("**" + param[0].split()[-1] + "** - " + param[0].split()[0] + ": " + param[1] + "<br>")
        file.write(" |\r\n")
        file.write("| Returns | " + document["return"] + " |\r\n")
    file.close()

def camelToKebab(s):
    subbed = kebabCompilerA.sub(r'\1-\2', s)
    return kebabCompilerB.sub(r'\1-\2', subbed).lower()

def main():
    if (len(sys.argv) > 1):
        with open(sys.argv[1], 'r') as file:
            content = file.read()

        comments = [processLine(line) for line in list(getComments(content))]

        for comment in comments:
            buildDocument(comment)
    else:
        print("No path given")

    generateDocumentation(documents)

if __name__ == '__main__':
    main()