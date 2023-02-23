pragma solidity ^0.8.0;

contract PredictionMarket {
    enum Outcome { Undecided, Yes, No }
    
    address public creator;
    uint256 public expirationTime;
    Outcome public outcome = Outcome.Undecided;
    uint256 public yesBalance;
    uint256 public noBalance;
    mapping(address => uint256) public balances;
    
    event NewPrediction(address indexed creator, uint256 indexed expirationTime);
    event NewBet(address indexed bettor, uint256 amount, Outcome indexed outcome);
    event OutcomeDecided(Outcome outcome);
    
    constructor(uint256 _expirationTime) {
        creator = msg.sender;
        expirationTime = _expirationTime;
        emit NewPrediction(creator, expirationTime);
    }
    
    function betYes() public payable {
        require(block.timestamp < expirationTime, "Prediction market has expired");
        require(outcome == Outcome.Undecided, "Prediction market outcome has already been decided");
        yesBalance += msg.value;
        balances[msg.sender] += msg.value;
        emit NewBet(msg.sender, msg.value, Outcome.Yes);
    }
    
    function betNo() public payable {
        require(block.timestamp < expirationTime, "Prediction market has expired");
        require(outcome == Outcome.Undecided, "Prediction market outcome has already been decided");
        noBalance += msg.value;
        balances[msg.sender] += msg.value;
        emit NewBet(msg.sender, msg.value, Outcome.No);
    }
    
    function decideOutcome(Outcome _outcome) public {
        require(msg.sender == creator, "Only the creator can decide the outcome");
        require(_outcome != Outcome.Undecided, "Outcome must be either Yes or No");
        outcome = _outcome;
        uint256 totalBalance = yesBalance + noBalance;
        uint256 winningBalance = outcome == Outcome.Yes ? yesBalance : noBalance;
        uint256 creatorFee = (totalBalance * 1) / 100;
        uint256 winnings = winningBalance + creatorFee;
        creator.transfer(creatorFee);
        for (uint256 i = 0; i < addressCount(); i++) {
            address bettor = addressAt(i);
            uint256 bettorBalance = balances[bettor];
            if (bettorBalance > 0) {
                uint256 bettorWinnings = (bettorBalance * winnings) / winningBalance;
                bettor.transfer(bettorWinnings);
            }
        }
        emit OutcomeDecided(outcome);
    }
    
    function addressCount() public view returns (uint256) {
        return balances.keys.length;
    }
    
    function addressAt(uint256 index) public view returns (address) {
        return balances.keys[index];
    }
}
