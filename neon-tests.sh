#!/bin/sh

set -e

wget -O docker-compose-test.yml https://raw.githubusercontent.com/neonlabsorg/proxy-model.py/develop/proxy/docker-compose-test.yml

# Run Neon
REVISION=v0.12.0 NEON_EVM_COMMIT=v0.12.0 FAUCET_COMMIT=v0.12.0 \
  docker-compose -f docker-compose-test.yml up -d --quiet-pull

# Run tests
MNEMONIC_PHRASE="slide clip fancy range predict resource stuff once all insect sniff acid"
docker run --rm --network host -e MNEMONIC_PHRASE="$MNEMONIC_PHRASE" \
  ghcr.io/inc4/yearn-vaults:master \
  bash -c " \
    brownie run scripts/neon_faucet.py --network neon && \
    brownie run scripts/neon_faucet.py --network neon && \
    brownie run scripts/neon_faucet.py --network neon && \
    brownie run scripts/neon_faucet.py --network neon && \
    brownie run scripts/neon_faucet.py --network neon && \
    brownie test \
      tests/functional/vault \
      tests/functional/registry \
      tests/functional/wrappers \
      tests/functional/strategy/test_strategy_health.py \
      tests/functional/strategy/test_clone.py \
      tests/functional/strategy/test_config.py \
      tests/functional/strategy/test_fees.py \
      tests/functional/strategy/test_misc.py \
      tests/functional/strategy/test_startup.py \
      tests/functional/strategy/test_shutdown.py \
      tests/functional/strategy/test_withdrawal.py \
      -v --network neon"

# Stop Neon
docker-compose -f docker-compose-test.yml down
