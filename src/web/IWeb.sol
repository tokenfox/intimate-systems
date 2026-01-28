// SPDX-License-Identifier: MIT
pragma solidity >=0.8.30;

import { IDecentralizedApp, KeyValue } from "../lib/Web3url.sol";

interface IWeb is IDecentralizedApp {
    function html() external view returns (string memory);
}
