import os
import json
import http.client
from brownie import accounts


def topup(account):
    conn = http.client.HTTPConnection("localhost:3333")
    conn.request('POST', '/request_neon', json.dumps({
        "wallet": account,
        "amount": 5000
    }))
    if conn.getresponse().status != 200:
        raise ValueError("topup failed")


def main():
    mnemonic_phrase = os.environ["MNEMONIC_PHRASE"]
    for acc in accounts.from_mnemonic(mnemonic_phrase, 10):
        topup(acc.address)
