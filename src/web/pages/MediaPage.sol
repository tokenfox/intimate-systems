// SPDX-License-Identifier: MIT
pragma solidity >=0.8.30;

import { WebLib } from "../WebLib.sol";
import { Sculpture } from "../../Sculpture.sol";
import { ContractShow } from "../../ContractShow.sol";

library MediaPage {
    function html(address show, uint256 index) public view returns (string memory) {
        Sculpture[] memory sculptures = WebLib.sortSculpturesByAuthor(ContractShow(show).getSculptures());
        if (index >= sculptures.length) {
            return "";
        }
        Sculpture sculpture = sculptures[index];
        string[] memory urls = WebLib.sculptureUrls(sculpture);
        string memory mimeUrl = WebLib.firstMimeUrl(urls);
        string memory title = WebLib.titleFor(sculpture);

        string memory mediaHtml;
        if (bytes(mimeUrl).length > 0) {
            (mediaHtml, ) = WebLib.renderMediaFromUrl(mimeUrl, title);
        } else {
            (string memory image, string memory animation) = WebLib.tokenMediaFor(sculpture, show);
            if (bytes(animation).length > 0) {
                (mediaHtml, ) = WebLib.renderMediaFromUrl(animation, title);
            } else if (bytes(image).length > 0) {
                (mediaHtml, ) = WebLib.renderImage(image, title);
            }
        }

        string
            memory css = "html,body{margin:0;padding:0;width:100%;height:100%;overflow:hidden;background:transparent}body{display:block}img,video{width:100%;height:100%;object-fit:contain;object-position:left top;display:block}iframe{border:0;width:100%;height:100%;display:block;overflow:hidden}";
        return
            string.concat(
                '<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><style>',
                css,
                "</style></head><body>",
                mediaHtml,
                "</body></html>"
            );
    }
}
