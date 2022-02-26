// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// import openzeppelin Contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

// we inherit the contract that we imported
contract MyEpicNFT is ERC721URIStorage {

    // OPENZEPPLIN HELP US TRACK OF TOKENIDS
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // baseSVG for all the NFTs
    // all we need to change is the words displayed
      string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Shinchan","Cold","Funny","Sunny","Cola","Blacky","Gamer","Pickachu","Thunder","Hannah","Drink","Letter","Box","Savana","War","Hercules","Bramha","Pacific","East","Antartic","Penguin"];
  string[] secondWords = ["Baby", "Guridan", "Doggy", "Cutie", "Ninja", "Doraemon","Welcome","Mild","Bronze","Snow","Lesson","Books","Bang","Mango","Project","Mission","Section","Horse","Unicorn","Bath"];
  string[] thirdWords = ["Nobitaaaa", "Sizuukka", "Flassshh", "Dogman", "Stoone", "Cheessee","Random","Power","Rangers","Hentai","Animal","Macdonald","Guava","Pommegrente","Seeds","Gold","Steel"];

  event NewEpicNFTMinted(address sender, uint256 tokenId);



    // pass hte name of our NFTs and it's symbol
    constructor() ERC721 ("SquareNFT", "Square") {
        console.log("This is openzepplin NFT contract");
   }

   function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }
  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }



   // func for user to get the NFT
   function makeAnEpicNFT() public {
       // get the current tokenId
       uint256 newItemId = _tokenIds.current();
       string memory first = pickRandomFirstWord(newItemId);
       string memory second = pickRandomSecondWord(newItemId);
       string memory third = pickRandomThirdWord(newItemId);

       string memory combineWord = string(abi.encodePacked(first,second,third));
       string memory finalSvg = string(abi.encodePacked(baseSvg,combineWord, "</text></svg>"));

        // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combineWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );


   
   
   
   
   string memory finalTokenUri = string(abi.encodePacked("data:application/json;base64,",json));
    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");


       // min the NFT to the sneder using msg.sender
       _safeMint(msg.sender, newItemId);

       // Set the NFT data
       _setTokenURI(newItemId, finalTokenUri);
       console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

       // Increment the counter
       _tokenIds.increment();
       emit NewEpicNFTMinted(msg.sender, newItemId);

   }


}