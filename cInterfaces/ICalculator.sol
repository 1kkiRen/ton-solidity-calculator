pragma ton-solidity >=0.57.0;
pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

interface ICalculator {
    
    // напишите интерфейс для контракта Calculator

    function addition(string x, string y) external pure returns (int);
    function subtraction(string x, string y) external pure returns (int);
    function multiplication(string x, string y) external pure returns (int);
    function division(string x, string y)  external pure returns (int);


}
