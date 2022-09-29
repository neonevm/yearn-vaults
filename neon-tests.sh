#!/bin/sh

set -e

wget -O docker-compose-test.yml https://raw.githubusercontent.com/neonlabsorg/proxy-model.py/develop/proxy/docker-compose-test.yml

# Run Neon
REVISION=v0.11.x NEON_EVM_COMMIT=v0.11.x FAUCET_COMMIT=latest \
  docker-compose -f docker-compose-test.yml up -d --quiet-pull

# Run tests
MNEMONIC_PHRASE="slide clip fancy range predict resource stuff once all insect sniff acid"
docker run --rm --network host -e MNEMONIC_PHRASE="$MNEMONIC_PHRASE" \
  ghcr.io/inc4/yearn-vaults:master \
  bash -c "brownie run scripts/neon_faucet.py && \
    brownie test tests/functional/vault/test_strategies.py -v --network neon && \
    brownie test tests/functional/vault/test_permit.py::test_permit -v --network neon && \
    brownie test tests/functional/strategy/test_strategy_health.py -v --network neon"

# Stop Neon
docker-compose -f docker-compose-test.yml down
