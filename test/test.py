import os
import sys

__dir__ = os.path.dirname(__file__)
sys.path.insert(0, os.path.dirname(__dir__))

import libparse

in_file = open(os.path.join(__dir__, "test.lib"))

x = libparse.LibertyParser(in_file)
ast = x.ast
default_operating_conditions = None
operating_conditions_raw = {}
for child in ast.children:
    if child.id == "default_operating_conditions":
        default_operating_conditions = child
    if child.id == "operating_conditions":
        operating_conditions_raw[child.args[0]] = child


if default_operating_conditions is None:
    if len(operating_conditions_raw) != 1:
        print("nooo!!!!")
        exit(-1)
    default_operating_conditions = operating_conditions_raw.values()[0]

print(default_operating_conditions.id, default_operating_conditions.value)
