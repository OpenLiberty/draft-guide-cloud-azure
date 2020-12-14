#!/bin/bash
set -euxo pipefail

# Test app

mvn -q clean package

cd inventory
mvn -q clean package liberty:create liberty:install-feature liberty:deploy
mvn liberty:start

cd ../system
mvn -q clean package liberty:create liberty:install-feature liberty:deploy
mvn liberty:start

cd ..

sleep 120

curl http://localhost:9080/system/properties
curl http://localhost:9081/inventory/systems/

mvn failsafe:integration-test -Dsystem.ip="localhost" -Dinventory.ip="localhost"
mvn failsafe:verify

cd inventory
mvn liberty:stop

cd ../system
mvn liberty:stop

# Clear .m2 cache
rm -rf ~/.m2
