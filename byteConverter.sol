// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ConvertByte{
    function getBytes32ArrayForInput() pure public returns (bytes32[3] memory b32Arr){
        b32Arr = [bytes32("Mubaraq"), bytes32("Ookan"), bytes32("Lawal")];
    }
}

/*
 [
     "0x4d75626172617100000000000000000000000000000000000000000000000000",
 "0x4f6f6b616e000000000000000000000000000000000000000000000000000000",
 "0x4c6177616c000000000000000000000000000000000000000000000000000000"
 ]
*/