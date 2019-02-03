#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Run, manage, configure and export Oavp sketches.

This script/CLI allows you to build, test and configure
Oavp sketches without mucking around in Processing or the
Processing IDE. It also allows you to generate documentation
based on pseudo-javadoc comments written in .pde files.
"""

import argparse
import os
import sys
import re
import subprocess

__author__ = "Nafeu Nasir"
__copyright__ = "Copyright 2019, Nafeu Nasir"
__credits__ = ["Nafeu Nasir"]
__license__ = "MIT"
__version__ = "0.0.1"
__maintainer__ = "Nafeu Nasir"
__email__ = "nafeu.nasir@gmail.com"
__status__ = "Development"

comments = []
content = ""
documents = []
default_return_desc = "Reference to self"
WIKI_URL = "https://github.com/nafeu/oavp/wiki/"
SKETCH_TEMPLATE = """
void setupSketch() {

}

void updateSketch() {

}

void drawSketch() {

}

void keyPressed() {

}

"""

parser = argparse.ArgumentParser(
    description='Run, manage, configure and export Oavp sketches.')

# Positional Arguments
parser.add_argument('sketch_path',
                    help="path of sketch to run",
                    nargs='?')

# Optional Arguments
parser.add_argument("-n", "--new-sketch",
                    help=("create a brand new sketch "
                          "inside the sketches directory"),
                    type=str,
                    metavar="sketch_name",
                    nargs=1)
parser.add_argument("-e", "--export-to",
                    help=("specify export path for compiled "
                          "processing app or generated docs"),
                    type=str,
                    metavar="path",
                    nargs=1)
parser.add_argument("-d", "--return-desc",
                    help="set default return description",
                    type=str,
                    metavar="return_desc",
                    nargs=1)
parser.add_argument("-g", "--generate-docs",
                    help=("specify .pde file and base class "
                          "to generate docs for"),
                    metavar=("pde_file", "base_class"),
                    type=str,
                    nargs=2)

args = parser.parse_args()


def get_comments(text):
    for comment in re.findall(r'\*\*(.*?)\)\ \{', text, re.S):
        yield re.sub('\n+', '|', re.sub(r'[ *]+', ' ', comment).strip())


def camel_to_kebab(s):
    subbed = re.compile(r'(.)([A-Z][a-z]+)').sub(r'\1-\2', s)
    return re.compile('([a-z0-9])([A-Z])').sub(r'\1-\2', subbed).lower()


def get_link(page_name):
    selection = page_name
    if "oavp" in page_name.lower():
        selection = page_name[4:]
    return "[" + page_name + "](" + WIKI_URL + selection + ")"


def process_line(input_line):
    return list(filter(None, [line.strip() for line in input_line.split("|")]))


def build_documentation(comment, base_class):
    if args.return_desc:
        default_return_desc = args.return_desc

    document = {
        "name": "",
        "syntax": [],
        "usage": "",
        "desc": "",
        "params": [],
        "return": {
            "type": "",
            "desc": ""
        },
        "references": [],
    }

    for index in range(len(comment)):
        key = comment[index].split()[0]
        if key == "@param":
            document["params"].append(comment[index][7:].split(" ", 1))
        elif key == "@return":
            document["return"]["desc"] = comment[index][8:]
        elif key == "@see":
            document["references"].append(comment[index][4:].strip())
        elif key == "@use":
            document["usage"] = comment[index][4:].strip()
        elif key == "/" or key[0] == "@":
            continue
        elif index == len(comment) - 1:
            declaration = comment[index].split("(")

            if len(document["usage"]) > 0:
                document["name"] = document["usage"] + \
                    "." + declaration[0].split()[-1]
            else:
                document["name"] = declaration[0].split()[-1]

            document["syntax"].append(
                document["name"] + "(" + declaration[-1] + ")")
            document["return"]["type"] = declaration[0].split()[1]

            args = [arg.strip() for arg in declaration[-1].split(",")]
            for index, value in enumerate(document['params']):
                try:
                    document['params'][index][0] = args[index]
                except IndexError:
                    print("Parameter mismatch for method '" +
                          document['name'] + "':")
                    print("Documented params: " + str(document['params']))
                    print("Arguments: " + str(args))
                    exit()
        else:
            document["desc"] += comment[index] + " "

    document["desc"] = document["desc"].strip()

    return_type = document["return"]["type"]
    return_desc = document["return"]["desc"]

    if len(return_desc) < 1 and return_type == base_class:
        return_desc = default_return_desc

    document["return"]["desc"] = document["return"]["desc"].strip()

    if (len(documents) > 0) and (documents[-1]["name"] == document["name"]):
        documents[-1]["syntax"].append(document["syntax"][0])
        documents[-1]["params"] = document["params"]
        documents[-1]["references"] = document["references"]
        documents[-1]["return"]["type"] = document["return"]["type"]
        documents[-1]["return"]["desc"] = document["return"]["desc"]
    else:
        documents.append(document)


def generate_documentation(documents):
    export_path = ""

    if args.export_to:
        export_path = args.export_to[0]
    else:
        export_path = "doc-export.md"
    print("Exporting docs to: %s" % export_path)

    file = open("%s.md" % export_path, "w+")
    file.write("#### Contents\r\n")

    for document in documents:
        file.write('* <a href="#%s">%s</a>\r\n' %
                   (camel_to_kebab(document["name"]), document["name"]))

    file.write("\r\n---\r\n")

    for document in documents:
        file.write("\r\n")
        file.write("<a name=\"" +
                   camel_to_kebab(document["name"]) + "\"/>\r\n")
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
                file.write("**" + param[0].split()[-1] + "** - " +
                           param[0].split()[0] + ": " + param[1] + "<br>")
            file.write(" |\r\n")

        if (document["return"]["type"] == "void"):
            file.write("| Returns | void |\r\n")
        else:
            file.write('| Returns | **%s**<br>%s |\r\n' %
                       (get_link(document["return"]["type"]),
                        document["return"]["desc"]))

        if len(document["references"]) > 0:
            file.write("| References | ")
            for reference in document["references"]:
                file.write(get_link(reference) + "<br>")
            file.write(" |\r\n")

    file.close()


def main():
    if args.new_sketch:
        with open("sketches/%s.oavp" % args.new_sketch[0], "w") as new_sketch:
            new_sketch.write(SKETCH_TEMPLATE)
            print("New sketch '%s' created at sketches/%s.oavp"
                  % (args.new_sketch[0], args.new_sketch[0]))
    elif args.sketch_path:
        final_path = args.sketch_path
        if (os.path.exists("./sketches/%s.oavp" % args.sketch_path)):
            final_path = "./sketches/%s.oavp" % args.sketch_path
        with open(final_path, "r") as sketch:
            with open("src/sketch.pde", "w") as dest:
                dest.write(sketch.read())

        subprocess.run(["processing-java",
                        "--sketch=%s/src/" % os.getcwd(),
                        "--force",
                        "--run"])
    elif args.generate_docs:
        with open(args.generate_docs[0], 'r') as file:
            content = file.read()
        comments = [process_line(line) for line in list(get_comments(content))]
        for comment in comments:
            build_documentation(comment, args.generate_docs[1])
        generate_documentation(documents)


if __name__ == '__main__':
    main()
