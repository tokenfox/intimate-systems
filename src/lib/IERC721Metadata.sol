// SPDX-License-Identifier: MIT
pragma solidity >=0.8.30;

interface IERC721Metadata {
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
