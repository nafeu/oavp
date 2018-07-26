import sys
import re

comments = []
content = ""
documents = []
kebabCompilerA = re.compile(r'(.)([A-Z][a-z]+)')
kebabCompilerB = re.compile('([a-z0-9])([A-Z])')
wikiUrl = "https://github.com/nafeu/oavp/wiki/"

def getComments(text):
    for comment in re.findall(r'\*\*(.*?)\)\ \{', text, re.S):
        yield re.sub('\n+', '|', re.sub(r'[ *]+', ' ', comment).strip())

def camelToKebab(s):
    subbed = kebabCompilerA.sub(r'\1-\2', s)
    return kebabCompilerB.sub(r'\1-\2', subbed).lower()

def getLink(pageName):
    selection = pageName
    if "oavp" in pageName.lower():
        selection = pageName[4:]
    return "[" + pageName + "](" + wikiUrl + selection + ")"

def processLine(inputLine):
    return list(filter(None, [line.strip() for line in inputLine.split("|")]))

def buildDocument(comment, baseClass, defaultReturnDesc):
    document = {
      "name": "",
      "syntax": [],
      "desc": "",
      "params": [],
      "return": {
        "type": "",
        "desc": ""
      },
      "references": [],
    }

    for index in range(len(comment)):
        key = comment[index].split()[0];
        if key == "@param":
            document["params"].append(comment[index][7:].split(" ", 1))
        elif key == "@return":
            document["return"]["desc"] = comment[index][8:]
        elif key == "@see":
            document["references"].append(comment[index][4:].strip())
        elif key == "/" or key[0] == "@":
            continue
        elif index == len(comment) - 1:
            declaration = comment[index].split("(")

            document["name"] = declaration[0].split()[-1]
            document["return"]["type"] = declaration[0].split()[1]
            document["syntax"].append(document["name"] + "(" + declaration[-1] + ")")

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

    if len(document["return"]["desc"]) < 1 and document["return"]["type"] == baseClass:
        document["return"]["desc"] = defaultReturnDesc

    document["return"]["desc"] = document["return"]["desc"].strip()

    if (len(documents) > 0) and (documents[-1]["name"] == document["name"]):
        documents[-1]["syntax"].append(document["syntax"][0])
        documents[-1]["params"] = document["params"]
        documents[-1]["references"] = document["references"]
        documents[-1]["return"]["type"] = document["return"]["type"]
        documents[-1]["return"]["desc"] = document["return"]["desc"]
    else:
        documents.append(document)

def generateDocumentation(documents):
    print("Generating docs...")

    file = open("doc-export.md", "w+")
    file.write("#### Contents\r\n")

    for document in documents:
        file.write("* <a href=\"#" + camelToKebab(document["name"]) +"\">" + document["name"] + "</a>\r\n")

    file.write("\r\n---\r\n")

    for document in documents:
        print(document)
        print("--------")
        file.write("\r\n")
        file.write("<a name=\"" + camelToKebab(document["name"]) + "\"/>\r\n")
        file.write("\r\n")
        file.write("| | <h2>" + document["name"] + "</h2> |\r\n")
        file.write("| :--- | :--- |\r\n")
        file.write("| Description | " + document["desc"] + " |\r\n")
        file.write("| Syntax | ")

        for syntax in document["syntax"]:
            file.write("`" + syntax + "`<br>")
        file.write(" |\r\n")

        if len(document["params"]) > 0:
            file.write("| Parameters | ")
            for param in document["params"]:
                file.write("**" + param[0].split()[-1] + "** - " + param[0].split()[0] + ": " + param[1] + "<br>")
            file.write(" |\r\n")

        if (document["return"]["type"] == "void"):
            file.write("| Returns | void |\r\n")
        else:
            file.write("| Returns | **" + getLink(document["return"]["type"]) + "**<br>" + document["return"]["desc"] + " |\r\n")

        if len(document["references"]) > 0:
            file.write("| References | ")
            for reference in document["references"]:
                file.write(getLink(reference) + "<br>")
            file.write(" |\r\n")

    file.close()

def main():
    baseClass = ""
    defaultReturnDesc = "Reference to self"

    if len(sys.argv) > 2:
        baseClass = sys.argv[2]

        if len(sys.argv) > 3:
            defaultReturnDesc = sys.argv[3]

        print("Base class: " + baseClass)
        print("Default return description: " + defaultReturnDesc)

        with open(sys.argv[1], 'r') as file:
            content = file.read()

        comments = [processLine(line) for line in list(getComments(content))]

        for comment in comments:
            buildDocument(comment, baseClass, defaultReturnDesc)

        generateDocumentation(documents)
    else:
        print("Missing arguments.")


if __name__ == '__main__':
    main()