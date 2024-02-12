// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract proposalContract {
        address owner;
        uint256 private counter;

        
        struct Proposal {
                string title; // title for the proposal
                string description;
                uint256 approve;
                uint256 reject;
                uint256 pass;
                uint256 total_vote_to_end;
                bool current_state;
                bool is_active;
        }
        
        mapping(uint256 => Proposal) proposal_history; // Recordings of previous proposals

        mapping(address => bool) public hasVoted; 

        address[] private voted_addresses;

        constructor() {
                owner = msg.sender;
                voted_addresses.push(msg.sender);

        }

        modifier onlyOwner () {
                require(msg.sender == owner);
                _;
        }

        modifier active() {
                require(proposal_history[counter].is_active == true, "The proposal is not active");
                         _;
                }

        modifier newVoter(address _address) {
                require(!isVoted(_address), "Address has already voted");
                   _;
                }

        function isVoted(address _address) internal view returns (bool) {
                return hasVoted[_address];
                }


        function setOwner(address new_owner) external onlyOwner {
                owner = new_owner;
        }

        function create(string calldata _title, string calldata _description, uint256 _total_vote_to_end) external {
        counter += 1;
        proposal_history[counter] = Proposal(_title, _description, 0, 0, 0, _total_vote_to_end, false, true);
        }

        function calculateCurrentState() private view returns(bool) {
                Proposal storage proposal = proposal_history[counter];

        // evaluate pass threshold, ensuring it's always an even number
        uint256 passThreshold = (proposal.pass % 2 == 0) ? proposal.pass : proposal.pass + 1;
                passThreshold /= 2;

        // verify the proposal is approved
                return proposal.approve > proposal.reject + passThreshold;
                }

        function vote(uint8 choice) external active newVoter(msg.sender) {
                Proposal storage proposal = proposal_history[counter];
                uint256 total_vote = proposal.approve + proposal.reject + proposal.pass;

                voted_addresses.push(msg.sender);

        

                if (choice == 1) {
                        proposal.approve += 1;
                        proposal.current_state = calculateCurrentState();
                } else if (choice == 2) {
                        proposal.reject += 1;
                        proposal.current_state = calculateCurrentState(); 
                } else if (choice == 0) {
                         proposal.pass += 1;
                         proposal.current_state = calculateCurrentState();
                }
                
                if ((proposal.total_vote_to_end - total_vote == 1) && (choice == 1 || choice == 2 || choice == 0)) {
                        proposal.is_active = false;
                        voted_addresses = [owner];
                }

        }     
}
