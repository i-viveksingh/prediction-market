# Prediction-Market

This contract allows users to bet on the outcome of a prediction market
where the outcome can be either "Yes" or "No". 
The contract keeps track of the balances for each outcome and the total balances for each better. 
The owner of the contract can decide the outcome and distribute the winnings to the users who bet on the winning outcome.
To use this contract, the creator must first deploy it and set the expirationTime to the time when the prediction market will expire. 
After the expiration time has passed, the creator can call the decideOutcome function to set the outcome and distribute the winnings to the users who bet on the winning outcome.
