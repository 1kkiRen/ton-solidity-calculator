pragma ton-solidity >=0.57.0;
pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

// Подключение библиотек и интерфейсов дебота
import "dLibraries/Debot.sol";
import "dInterfaces/Terminal.sol";
import "dInterfaces/NumberInput.sol";
import "dInterfaces/Menu.sol";

// Подключение интерфейса контракта
import "cInterfaces/ICalculator.sol";

contract CalculatorDebot is Debot {

    address addrCalculator;
    uint32 idOperation;
    string x;

    constructor(address _addrCalculator) public {
        require(tvm.pubkey() != 0, 101);
        require(tvm.pubkey() == msg.pubkey(), 102);
        tvm.accept();
        addrCalculator = _addrCalculator;
    }

    // опишите ваш дебот
    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "";
        version = "";
        publisher = "";
        key = "";
        author = "";
        support = address.makeAddrStd(0, 0x0);
        hello = "";
        language = "en";
        dabi = m_debotAbi.get();
        icon = "";
    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [
            NumberInput.ID,
            Menu.ID,
            Terminal.ID
        ];
    }

    function setCalculatorAddress(address _addrCalculator) public {
        tvm.accept();
        addrCalculator = _addrCalculator;
    }

    // Начало работы дебота
    function start() public override {
        mainMenu();
    }

    function mainMenu() public {
        Menu.select("==What to do?==", "", 
        [
            MenuItem("Addition", "", tvm.functionId(setOperation)),
            MenuItem("Subtraction", "", tvm.functionId(setOperation)),
            MenuItem("Multiplication", "", tvm.functionId(setOperation)),
            MenuItem("Division", "", tvm.functionId(setOperation)),
            MenuItem("Exit", "", tvm.functionId(exit))
        ]);
    }

    function setOperation(uint32 index) public {
        Terminal.print(0, format("Chosen: {}", index));
        if ( index == 0 ) {
            idOperation = tvm.functionId(addition);
        } else if ( index == 1 ) {
            idOperation = tvm.functionId(subtraction);
        } else if ( index == 2 ) {
            idOperation = tvm.functionId(multiplication);
        } else if ( index == 3 ){   
            idOperation = tvm.functionId(division);
        } 
        Terminal.input(tvm.functionId(setX), "First number:", false);
    }

    function setX(string value) public {
        x = value;
        Terminal.input(idOperation, "Second number:", false);
    }

    function addition(string value) public view {
        optional(uint256) none;
        ICalculator(addrCalculator).addition{
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(printResult),
            onErrorId: tvm.functionId(onError)
        }(x, value).extMsg;
    }

    function subtraction(string value) public view {
        optional(uint256) none;
        ICalculator(addrCalculator).subtraction{
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(printResult),
            onErrorId: tvm.functionId(onError)
        }(x, value).extMsg;
    }

    function multiplication(string value) public view {
        optional(uint256) none;
        ICalculator(addrCalculator).multiplication{
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(printResult),
            onErrorId: tvm.functionId(onError)
        }(x, value).extMsg;
    }

    function division(string value) public view {
        optional(uint256) none;
        ICalculator(addrCalculator).division{
            sign: false,
            pubkey: none,
            time: uint64(now),         
            expire: 0,
            callbackId: tvm.functionId(printResult),
            onErrorId: tvm.functionId(onError)
        }(x, value).extMsg;
    }

    function printResult(int res) public view{
        Terminal.print(tvm.functionId(mainMenu), format("Result: {}", res));
    }

    function exit(uint32 index)public view{
        index;
        Terminal.print(0, "Goodbay!");
    }

    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
    }
}


// https://web.ton.surf/debot?address=0%3Aa4e53e34557aa6223de4f6a840eb9c1f2fdb18fed1d75f158651976b743adc5f&net=devnet