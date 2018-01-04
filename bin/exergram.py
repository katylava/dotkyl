#!/usr/bin/env python3

import json
import os
import random
import sys

from collections import namedtuple


with open(os.path.expanduser('~/Dropbox/exercises/exercises.json')) as fh:
    _EXERCISES = json.load(fh)

Exercise = namedtuple('Exercise', ['name', 'effort', 'kind', 'equipment'])
EXERCISES = [Exercise(**x) for x in _EXERCISES]


def select(num, kind=None, effort=None, equipment=None):
    """ Select random `num` exercises matching kwarg filters """
    exercises = EXERCISES

    equipment = equipment + [''] if equipment else ['']

    if kind and kind != ['any']:
        exercises = [x for x in exercises if x.kind in kind]
    if effort:
        exercises = [x for x in exercises if x.effort <= effort]
    if equipment:
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
        return [x, rest]

    sorted = []
    current = None

    while len(exercises):
        next, exercises = getnext(exercises, current)
        sorted.append(next)
        current = next

    return sorted


if __name__ == '__main__':
    num = int(sys.argv[1])
    effort = int(sys.argv[2])
    kind = sys.argv[3].split(',') if len(sys.argv) > 3 else None
    equipment = sys.argv[4].split(',') if len(sys.argv) > 4 else None

    exercises = collate(select(num, kind, effort, equipment))

    longest_name = max([len(x.name) for x in exercises])
    longest_kind = max([len(x.kind) for x in exercises])
    tpl = '{name:<{name_width}} {kind:<{kind_width}} {effort:<13} {equipment}'

    print(tpl.format(
        name='Name',
        name_width=longest_name + 4,
        kind='Kind',
        kind_width=longest_kind + 4,
        effort='Effort',
        equipment='Equipment',
    ))

    print('━' * (longest_name + 4 + 1 + longest_kind + 4 + 1 + 13 + 1 + 9))

    for x in exercises:
        print(tpl.format(
            name=x.name,
            name_width=longest_name + 4,
            kind=x.kind,
            kind_width=longest_kind + 4,
            effort=['easy', 'medium', 'hard', 'very hard'][x.effort - 1],
            equipment=x.equipment or '--',
        ))

    print('\n\nImages\n━━━━━━')

    for x in exercises:
        image_path = '{}/{}.gif'.format(
            os.path.expanduser('~/Dropbox/exercises'),
            x.name.lower().replace(' ', '-')
        )

        if os.path.exists(image_path):
            print('{}: {}'.format(x.name, image_path))

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
