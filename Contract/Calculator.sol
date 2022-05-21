pragma ton-solidity >=0.57.0;
pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

contract Calculator{

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(tvm.pubkey() == msg.pubkey(), 102);
        tvm.accept();
    }

// Сложение

    function addition(string x, string y) public pure returns (int){
        return int(str_to_num(x) + str_to_num(y));
    }

// Вычетание
    function subtraction(string x, string y) public pure returns (int){
        return int(str_to_num(x)) - int(str_to_num(y));
    }

// Умножение
    function multiplication(string x, string y) public pure returns (int){
        return int(str_to_num(x) * str_to_num(y));
    }

// Деление
    function division(string x, string y)  public pure returns (int){
        return int(str_to_num(x) / str_to_num(y));
    }

// Привод строки к числовому значению
    function str_to_num(string value) public pure returns(uint) {
        uint val;
        bytes stringBytes = bytes(value);
        for (uint i = 0; i < stringBytes.length; i++) {
            uint exp = stringBytes.length - i;
            bytes1 ival = stringBytes[i];
            uint8 uval = uint8(ival);
            uint jval = uval - uint(0x30);
   
           val +=  (uint(jval) * (10**(exp-1))); 
        }
      return val;
    }

}
