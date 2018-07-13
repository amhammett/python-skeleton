import json
import os
from argparse import ArgumentParser

LOOKUP_FILE = os.path.join(os.getcwd(), 'data', 'lookup.json')


def read_branches():
    data = []

    if os.path.isfile(LOOKUP_FILE):
        data = json.load(open(LOOKUP_FILE, 'r'))

    return data


def parse_arguments(args=None):
    parser = ArgumentParser()
    parser.add_argument('--search', default='foo', help="Provide search term to lookup")
    return parser.parse_args(args)


def main():
    print("Skeleton Search")
    args = parse_arguments()

    if args.search:
        print(args.search)


if __name__ == '__main__':
    main()
