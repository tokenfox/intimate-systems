// SPDX-License-Identifier: MIT
pragma solidity >=0.8.30;

import { LibString } from "solady/utils/LibString.sol";
import { Sculpture } from "../../Sculpture.sol";
import { Essay } from "../../Essay.sol";
import { Mod } from "../../Mod.sol";
import { Layout } from "../Layout.sol";

// TODO
library EssayPage {
    function html(address show, address essayContract, address data) public view returns (string memory _html) {
        _html = string.concat(
            '<main class="gallery-flow">',
            '<section class="intro-section">',
            '<p class="intro-subtitle"><i>This text was published as part of the contract show: <a href="/">',
            Sculpture(show).title(),
            "</a></i></p>",
            "<br><br><br>",
            '<article class="sculpture-text">',
            Essay(essayContract).html(),
            "</article>",
            "<br><br>",
            '<p class="intro-meta">',
            '<a href="',
            Mod(data).etherscanBase(),
            LibString.toHexStringChecksummed(show),
            '" target="_blank" rel="noopener">',
            LibString.toHexStringChecksummed(show),
            "</a>",
            "</p>",
            "</section>",
            "</main>"
        );

        string memory description = string.concat(
            'The essay "',
            Essay(essayContract).title(),
            '" written by ',
            Mod(data).essayAuthor(),
            " was published as part of the contract show: ",
            Sculpture(show).title()
        );

        return Layout.html(_html, Essay(essayContract).title(), description);
    }
}
