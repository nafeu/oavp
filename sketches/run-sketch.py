import os
import subprocess

print(os.getcwd())

with open("test-sketch.oavp", "r") as sketch:
    with open("../src/sketch.pde", "w") as dest:
        dest.write(sketch.read())

subprocess.run(["processing-java", "--sketch=" + os.getcwd() + "../src/", "--force", "--run"])