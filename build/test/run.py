#!/bin/env python

import os
import subprocess


root_dir = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '../..'))

cmd = [
    'xrun',
    '-incdir', os.path.join(root_dir, 'src/main/headers'),
    '-incdir', os.path.join(root_dir, 'src/main/sv'),
    os.path.join(root_dir, 'src/main/sv/gent_constraints.sv'),
    os.path.join(root_dir, 'src/test/sv/test.sv'),
    ]

subprocess.check_call(cmd)
