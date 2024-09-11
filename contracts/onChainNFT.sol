// contracts/onChainNFT.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract OnChainNFT is ERC721URIStorage {
    event Minted(uint256 tokenId);

    constructor() ERC721("OnChainNFT", "ONC") {}

    /* Converts an SVG to Base64 string */
    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(svg));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

    /* Generates a basic SVG with CID included */
    function generateSVGImage(
        string memory cid
    ) public pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<svg xmlns="http://www.w3.org/2000/svg" height="400" width="400">',
                    '<rect width="100%" height="100%" fill="black"/>',
                    '<text x="50%" y="50%" fill="white" font-size="24" dominant-baseline="middle" text-anchor="middle">',
                    cid,
                    "</text></svg>"
                )
            );
    }

    /* Generates a tokenURI using the Base64 string as the image */
    function formatTokenURI(
        string memory imageURI
    ) public pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "LCM ON-CHAINED", "description": "A simple SVG based on-chain NFT with CID", "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    /* Mints the token using a CID */
    function mint(uint256 tokenId, string memory cid) public {
        string memory svg = generateSVGImage(cid);
        string memory imageURI = svgToImageURI(svg);
        string memory tokenURI = formatTokenURI(imageURI);

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);

        emit Minted(tokenId);
    }
}
