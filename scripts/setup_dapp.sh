#!/bin/bash
# Example commands to run after creating a new repo with the dapp template...
#
find . -type f -name '*.ex' -exec sed -i '' s/Dapp/FIXME/g {} +
find . -type f -name '*.exs' -exec sed -i '' s/Dapp/FIXME/g {} +

mv lib/dapp lib/fixme
mv lib/dapp.ex lib/fixme.ex
mv test/dapp test/fixme

find . -type f -name '*.ex' -exec sed -i '' s/dapp/fixme/g {} +
find . -type f -name '*.exs' -exec sed -i '' s/dapp/fixme/g {} +

