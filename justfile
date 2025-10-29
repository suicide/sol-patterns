alias b := build
alias t := test

default:
  just --list

# build
build:
  forge build --sizes

# build all
build-all: build test solhint

# test
test-quick $FOUNDRY_PROFILE="quick":
  forge test

test $FOUNDRY_PROFILE="perf":
  forge test --gas-report

# test contract
test-contract CONTRACT $FOUNDRY_PROFILE="perf":
  forge test -vvv --gas-report --match-contract {{CONTRACT}}

# run solhint
solhint:
  pnpm run solhint

# clean all
clean: forge-clean

forge-clean:
  forge clean