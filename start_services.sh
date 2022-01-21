#!/usr/bin/bash

ROOT_DIR="/home/limkb/group_project"
###############################################
# subdirectories
#
# ├── Bank_Portal
# │   ├── public
# │   └── src
# │       ├── Assets
# │       └── Components
# ├── Node_utilities
# ├── bridgeA
# ├── bridgeB
# ├── complianceA
# ├── complianceB
# ├── federationA
# └── federationB

## to start all process
echo "Starting proceses"
echo "current ps"
netstat -tulpn | sort
echo ""

## starting docker
echo "Check if Stellar docker is running ..."
echo ""
if pgrep "stellar" > /dev/null
then
	echo "Stellar docker is already running"
	echo ""
	docker ps
	echo "Stellar docker is not running. To start it now"
else
	echo "Stellar docker is not running"
	echo "Starting Stellar docker now"
	docker run --rm -it -p "8000:8000" -d -v "/home/limkb/stellar:/opt/stellar" --name stellar stellar/quickstart --standalone
	#docker run --rm -it -p "8000:8000" -d --name stellar stellar/quickstart --standalone
	sleep 5
	echo ""
	docker ps
fi

echo ""
echo "================================================================"
echo ""


## restarting postgres
echo "Starting postgres at port 5433"
echo "sudo service postgresql restart"
sudo service postgresql restart
sleep 10

echo ""
echo "================================================================"
echo ""

su - postgres
psql 



## restarting apache2
echo "Starting apache2"
echo "sudo service apache2 restart"
sudo service apache2 restart

echo ""
echo "================================================================"
echo ""

# ##
# ## Create Stellar accounts
# echo "Creating user accounts"
# SERVICE="CreateAccount"
# cd $ROOT_DIR/Node_utilities
# node ./CreateAccount.js  > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 & 

# echo ""
# echo "================================================================"
# echo ""

# ## Create asset (USD)
# echo "Creating asset - USD"
# SERVICE="USDAsset"
# node ./USDAsset.js  > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 & 

# echo ""
# echo "================================================================"
# echo ""

# ## Fund accounts with asset created
# echo "Funding accounts with USD"
# SERVICE="TransferUSD1"
# node ./TransferUSD1.js  > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 & 

# SERVICE="TransferUSD2"
# node ./TransferUSD2.js  > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 & 

##  federationA and federationB 
echo "starting federal server"

echo ""
echo "================================================================"
echo ""


SERVICE="federationA"
cd $ROOT_DIR/federationA
 ./federation > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 &
echo ""
sleep 1

SERVICE="federationA"
cd $ROOT_DIR/federationB
 ./federation > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 &
echo ""
sleep 1

echo ""
echo "================================================================"
echo ""


# # ## complianceA and complianceB 
echo "starting compliance server"

SERVICE="complianceA"
cd $ROOT_DIR/complianceA
./compliance --migrate-db 
./compliance  > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 &
echo ""

SERVICE="complianceB"
cd $ROOT_DIR/complianceB
./compliance --migrate-db 
./compliance  > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 &
echo ""

echo ""
echo "================================================================"
echo ""


## bridgeA and bridgeB 
echo "starting bridge server"

#read -p "Press any key to resume ..."
SERVICE="bridgeA"
cd $ROOT_DIR/bridgeA
./bridge --migrate-db 
 ./bridge > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 &
echo ""

SERVICE="bridgeB"
cd $ROOT_DIR/bridgeB
./bridge --migrate-db 
 ./bridge   > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 &
echo ""

echo ""
echo "================================================================"
echo ""


cd $ROOT_DIR/Node_utilities

sleep 3

## CallbacksA and CallbacksB
echo "starting Callback server"
SERVICE="CallbacksA"
 node ./CallbacksA.js > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 & 

SERVICE="CallbacksB"
 node ./CallbacksB.js > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 & 
echo ""

sleep 3

## DBServerA.js and node DBServerB.j
# echo "starting backend server"
#read -p "Press any key to resume ..."
SERVICE="Backend_Server_A"
node ./DBServerA.js  > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 &

SERVICE="Backend_Server_B"  
node ./DBServerB.js  > $SERVICE-`date '+%Y%m%d-%H%M%S'`.out 2>&1 &

echo ""
echo "================================================================"
echo ""


## start frontend
echo "Starting frontend"
cd $ROOT_DIR/Bank_Portal
npm start&
echo ""
echo "================================================================"
echo ""


## check processes status 
echo "Final status: "
sleep 30
netstat -tulpn | sort


### action to be performed on every round of testing

## ./start_services.sh 2>&1 | tee start_services-`date '+%Y%m%d-%H%M%S'`.out
# 
# sudo su - postgres
# psql
# DROP DATABASE bridgea;
# DROP DATABASE bridgeb;
# DROP DATABASE compliancea;
# DROP DATABASE complianceb;

# CREATE DATABASE bridgea OWNER bankauser;
# CREATE DATABASE bridgeb OWNER bankbuser;
# CREATE DATABASE compliancea OWNER bankauser;
# CREATE DATABASE complianceb OWNER bankbuser;