// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract {

        struct proposal {
                string title; // title for the proposal
                string description;
                uint256 approve;
                uint256 reject;
                uint256 pass;
                uint256 total_vote_to_end;
                bool current_states;
                bool is_active;
        }

        // Recording previous proposal, indexing with a uint256 key value

        mapping(uint256 => proposal) proposal_history;
}
