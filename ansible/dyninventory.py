#!/usr/bin/env python
import os
import argparse
import json
from python_terraform import *

parser = argparse.ArgumentParser(description='Generate inventory.json')
parser.add_argument('--list', action='store_true', help='Return all hosts')
parser.add_argument('--host')

args = parser.parse_args()

CUR_DIR = os.path.dirname(os.path.abspath(__file__))
WORK_DIR = os.path.abspath(os.path.join(CUR_DIR, '../terraform/stage'))

if not os.path.isdir(WORK_DIR):
    raise Exception('Path `%s` not found' % (WORK_DIR,))

tf = Terraform(working_dir=WORK_DIR)
vars = tf.output()

output = {
    'app': {
        'hosts': [vars['app_external_ip']['value']]
    },
    'db': {
        'hosts': [vars['db_external_ip']['value']]
    },
    '_meta': {
        'hostvars': {}
    }
}

if args.host:
    if args.host not in output:
        raise Exception('Host `%s` not found' % (args.host,))
    
    print(json.dumps(output[args.host]))
else:
    print(json.dumps(output))
