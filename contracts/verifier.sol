// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract msgVer {

    address public owner;
    uint256 id = 0;
    uint256 nonce;
    constructor(uint256 nonce_){
        owner = msg.sender;
        nonce = nonce_;
    }

    mapping (uint256 => uint256) signatureDate;
    mapping (uint256 => string) text;
    mapping (uint256 => uint256) number1;
    mapping (uint256 => uint256) number2;
    mapping (uint256 => bool) ownable;
    mapping (uint256 => address) ownerOf;
    mapping (uint256 => uint256) encryptedToPublicId;
    mapping (uint256 => string) ownerName;

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }


    function signDocument(string memory text_, bool ownable_) public onlyOwner() returns(uint256 returnedN1, uint256 returnedN2){
        uint256 num1 = uint256(keccak256(abi.encodePacked(nonce , block.timestamp)));
        number1[num1] = id;
        nonce++;

        uint256 num2 = uint256(keccak256(abi.encodePacked(nonce , block.timestamp)));
        number2[num2] = id;
        nonce++;

        uint256 signatureId = uint256(keccak256(abi.encodePacked(num1, num2)));
        encryptedToPublicId[signatureId] = id;

        text[signatureId] = text_;
        signatureDate[signatureId] = block.timestamp;
        ownable[signatureId] = ownable_;
        id++;

        return (num1, num2);
    }
    
    function getData(uint256 num1, uint256 num2) public view returns(string memory returnedText, uint256 returnedDate, bool ownability){

        require(number1[num1] == number2[num2], "Document not found");
        uint256 signatureId = uint256(keccak256(abi.encodePacked(num1, num2)));
        return(text[signatureId], signatureDate[signatureId], ownable[signatureId]);
    }

    function ownDocument(uint256 num1, uint256 num2, string memory yourname_) public returns (uint256 yourId){

        require (number1[num1] == number2[num2], "Document not found");
        uint256 signatureId = uint256(keccak256(abi.encodePacked(num1, num2)));
        require (ownerOf[signatureId] == address(0x0), "Ownership already claimed");
        require (ownable[signatureId] == true);
        ownerName[signatureId] = yourname_;
        ownerOf[encryptedToPublicId[signatureId]] = msg.sender;

        return encryptedToPublicId[signatureId];
    }

    function viewOwner(uint id_) public view returns(address Owner) {
        return ownerOf[id_];
    }
}