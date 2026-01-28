// SPDX-License-Identifier: MIT
pragma solidity >=0.8.30;

import { Layout } from "../Layout.sol";
import { WebLib } from "../WebLib.sol";
import { Sculpture } from "../../Sculpture.sol";
import { ContractShow } from "../../ContractShow.sol";
import { Mod } from "../../Mod.sol";
import { IERC721Metadata } from "../../lib/IERC721Metadata.sol";
import { LibString } from "solady/utils/LibString.sol";
import { Base64 } from "solady/utils/Base64.sol";
import { JSONParserLib } from "solady/utils/JSONParserLib.sol";

library IndexPage {
    using LibString for string;
    using LibString for address;
    using LibString for uint256;
    using JSONParserLib for JSONParserLib.Item;
    using JSONParserLib for string;

    function html(address show, address data) public view returns (string memory) {
        string memory body = string.concat(
            _introHtml(show, data),
            _aboutHtml(data),
            _worksHtml(show, data),
            _footerHtml(show, data)
        );
        string memory description = Mod(data).description();
        return Layout.html(body, Sculpture(show).title(), description);
    }

    function _introHtml(address show, address data) internal view returns (string memory _html) {
        Sculpture[] memory sculptures = WebLib.sortSculpturesByAuthor(ContractShow(show).getSculptures());
        string memory artistList = WebLib.artistsList(sculptures);
        string memory showAddr = show.toHexStringChecksummed();

        _html = string.concat(
            '<main class="gallery-flow">',
            '<section id="intro" class="intro-section">',
            '<h1 class="intro-title">',
            Sculpture(show).title(),
            "</h1>"
        );

        _html = string.concat(
            _html,
            '<p class="intro-subtitle">',
            "A contract show curated by ",
            '<a href="',
            Mod(data).curatorUrl(),
            '" target="_blank" rel="noopener">',
            Mod(data).curator(),
            "</a>",
            " with ",
            '<a href="',
            Mod(data).superrareUrl(),
            '" target="_blank" rel="noopener">',
            Mod(data).superrare(),
            "</a>",
            "</p>"
        );

        _html = string.concat(
            _html,
            '<p class="intro-artists">',
            artistList,
            "</p>",
            '<p class="intro-essay"><a href="/essay">Essay by ',
            Mod(data).essayAuthor(),
            unicode" →</a></p>",
            '<p class="intro-thanks">',
            "<span>Special thanks to</span> ",
            '<a href="',
            Mod(data).thanksUrl(),
            '" target="_blank" rel="noopener">',
            Mod(data).thanks(),
            "</a>",
            "<span> et al. for lighting the path with</span> ",
            '<a href="',
            Mod(data).thanksShowUrl(),
            '" target="_blank" rel="noopener">',
            Mod(data).thanksShow(),
            "</a>",
            "</p>"
        );

        _html = string.concat(
            _html,
            '<p class="intro-meta">',
            "<span>December 1, 2025</span>",
            '<a href="',
            Mod(data).etherscanBase(),
            showAddr,
            '" target="_blank" rel="noopener">',
            showAddr,
            "</a>",
            "</p>",
            "</section>"
        );
    }

    function _aboutHtml(address data) internal view returns (string memory _html) {
        _html = string.concat(
            '<section id="about" class="about-section">',
            '<div class="about-content">',
            Mod(data).text(),
            "</div>",
            "</section>"
        );
    }

    function _worksHtml(address show, address data) internal view returns (string memory _html) {
        Sculpture[] memory sculptures = WebLib.sortSculpturesByAuthor(ContractShow(show).getSculptures());
        _html = string.concat(
            '<section id="works" class="works-section">',
            '<div id="sculptures" class="sculptures-container">'
        );

        for (uint256 i = 0; i < sculptures.length; i++) {
            _html = _html.concat(_sculptureHtml(sculptures[i], i, data));
        }

        _html = string.concat(_html, "</div>", "</section>");
    }

    function _sculptureHtml(
        Sculpture sculpture,
        uint256 index,
        address data
    ) internal view returns (string memory _html) {
        string memory authorsText = WebLib.authorsTextFor(sculpture);
        string memory title = WebLib.titleFor(sculpture);
        string memory text = WebLib.formatText(WebLib.textFor(sculpture));
        string[] memory urls = WebLib.sculptureUrls(sculpture);
        string memory artworkUrl = WebLib.firstMimeUrl(urls);
        string memory mediaHtml = WebLib.mediaIframe(index);
        string memory linksHtml = WebLib.linksHtmlFor(urls, artworkUrl);
        string memory addressesHtml = WebLib.addressesFor(sculpture, data);

        _html = string.concat(
            '<article class="sculpture" id="',
            WebLib.slugify(WebLib.primaryAuthor(sculpture)),
            '">',
            '<div class="sculpture-header">',
            '<div class="sculpture-authors">',
            authorsText,
            "</div>",
            '<h2 class="sculpture-title">',
            title,
            "</h2>",
            "</div>",
            '<div class="sculpture-media">',
            mediaHtml,
            "</div>",
            '<div class="sculpture-text">'
        );

        _html = string.concat(
            _html,
            text,
            linksHtml,
            '<div class="sculpture-footer">',
            addressesHtml,
            "</div>",
            "</div>",
            "</article>"
        );
    }

    function _footerHtml(address show, address data) internal view returns (string memory _html) {
        string memory showAddr = show.toHexStringChecksummed();
        _html = string.concat(
            '<footer class="footer-section">',
            '<div class="footer-content">',
            '<div class="project-info">',
            "<p>Generated in block ",
            block.number.toString(),
            " from ",
            '<a href="',
            Mod(data).etherscanBase(),
            showAddr,
            '" target="_blank" rel="noopener">',
            showAddr,
            "</a>",
            "</p>",
            "</div>",
            "</div>",
            "</footer>",
            "</main>"
        );
    }
}
