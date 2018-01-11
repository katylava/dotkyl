#!/usr/bin/env python3

import json
import os
import random
import sys

from collections import namedtuple


EXERCISE_FILE = os.path.expanduser('~/Dropbox/exercises/exercises.json')

if not os.path.exists(EXERCISE_FILE):
    print('No exercises.json found at ~/Dropbox/exercises/')
    sys.exit(1)

with open(EXERCISE_FILE) as fh:
    _EXERCISES = json.load(fh)

Exercise = namedtuple('Exercise', [
    'name', 'effort', 'kind', 'equipment', 'hidden', 'symmetric'
])
EXERCISES = [Exercise(**x) for x in _EXERCISES]
EFFORT_LEVELS = ['easy', 'medium', 'hard', 'very hard']


def select(num, kind=None, effort=None, equipment=None):
    """ Select random `num` exercises matching kwarg filters """
    exercises = [x for x in EXERCISES if not x.hidden]

    equipment = equipment + [None] if equipment else [None]

    if kind and kind != ['any']:
        exercises = [x for x in exercises if x.kind in kind]
    if effort:
        exercises = [x for x in exercises if x.effort <= effort]
    if equipment and equipment != ['any']:
        exercises = [x for x in exercises if x.equipment in equipment]

    num = len(exercises) if num > len(exercises) else num
    return random.sample(exercises, num)


def collate(exercises):
    """ Sort exercises so effort and kind changes between each
    ...as best as possible.
    """

    def getnext(rest, current=None):
        if not current:
            x = rest.pop(0)
            return [x, rest]
        for x in rest:
            if x.effort != current.effort and x.kind != current.kind:
                rest.remove(x)
                return [x, rest]
        for x in rest:
            if x.effort != current.effort:
                rest.remove(x)
                return [x, rest]
        for x in rest:
            if x.kind != current.kind:
                rest.remove(x)
                return [x, rest]
        rest.remove(x)
        return (x, rest)

    collated = []
    current = None

    while len(exercises):
        next, exercises = getnext(exercises, current)
        collated.append(next)
        current = next

    return collated


def print_exercises(exercises):
    """ Output exercise info to stdout """
    tpl = (
        '{name:<{name_width}}{kind:<{kind_width}}{effort:<{effort_width}}'
        '{equipment:<{equipment_width}}{asymmetric}'
    )

    name_width = max([len(x.name) for x in exercises]) + 4
    kind_width = max([len(x.kind) for x in exercises]) + 4
    effort_width = max([len(effort) for effort in EFFORT_LEVELS]) + 4
    equipment_width = max([len(x.equipment or '') for x in exercises]) + 4

    print(tpl.format(
        name='Name',
        kind='Kind',
        effort='Effort',
        equipment='Eq.',
        asymmetric='',
        name_width=name_width,
        kind_width=kind_width,
        effort_width=effort_width,
        equipment_width=equipment_width,
    ))

    print('━' * (name_width + kind_width + effort_width + equipment_width + 4))

    for x in exercises:
        print(tpl.format(
            name=x.name,
            kind=x.kind,
            effort=EFFORT_LEVELS[x.effort - 1],
            equipment=x.equipment or '--',
            asymmetric='  ⨉2' if not x.symmetric else '',
            name_width=name_width,
            kind_width=kind_width,
            effort_width=effort_width,
            equipment_width=equipment_width,
        ))

    print('\n\nImages\n━━━━━━')

    for x in exercises:
        image_path = '{}/{}.gif'.format(
            os.path.expanduser('~/Dropbox/exercises'),
            x.name.lower().replace(' ', '-')
        )

        if os.path.exists(image_path):
            print('{}: {}'.format(x.name, image_path))


def print_usage():
    kinds = list(set([x.kind for x in EXERCISES]))
    equipments = list(set([x.equipment for x in EXERCISES if x.equipment]))
    print("""
        exergram.py [num exercises] <max effort> <kind> <equipment>

        Reads a list of exercises from a json file at
        ~/Dropbox/exercises/exercises.json and selects `num exercises`
        randomly, collates them by effort and kind, and outputs list
        to stdout.

        num exercises:  the number of exercises you want to output.
        max effort:     a number 1-4 with 1 being easy and 4 being very hard
                        -- default 4
        kind:           a comma-separated list to filter exercises by kind. The
                        special value "any" will match all exercises.
                        Options: {kinds}
        equipment:      a comma-separated list of available equipment. By
                        default only exercises which require no equipment are
                        selected.  Specifying equipment will include exercises
                        which require that equipment as well as any which
                        require none.
                        Options: {equipments}
    """.format(kinds=', '.join(kinds), equipments=', '.join(equipments)))


if __name__ == '__main__':
    if len(sys.argv) <= 2:
        print_usage()
        sys.exit()

    num = int(sys.argv[1])
    effort = int(sys.argv[2])
    kind = sys.argv[3].split(',') if len(sys.argv) > 3 else None
    equipment = sys.argv[4].split(',') if len(sys.argv) > 4 else None

    print_exercises(collate(select(num, kind, effort, equipment)))

# Copyright (c) 2018 Kathleen LaVallee <katylava@gmail.com>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
