- include .env


deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(RPC_URL_SEPOLIA) --private-key $(META1_PRIVATE_KEY) --broadcast -vvvv