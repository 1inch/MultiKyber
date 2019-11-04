// const { expectRevert } = require('openzeppelin-test-helpers');
// const { expect } = require('chai');

const MultiOasis = artifacts.require('MultiOasis');

const OasisAddress = '0x39755357759cE0d7f32dC8dC45414CCa409AE24e';
const CompoundComptroller = '0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B';

const WETH = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2';
const DAI = '0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359';
const cETH = '0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5';
const cDAI = '0xF5DCe57282A584D2746FaF1593d3121Fcac444dC';

contract('MultiOasis', function ([_, addr1]) {
    describe('MultiOasis', async function () {
        before(async function () {
            this.multiOasis = await MultiOasis.new(
                OasisAddress,
                CompoundComptroller,
                cETH,
            );
        });

        it('should work getBuyAmount WETH => DAI', async function () {
            const returnAmount = await this.multiOasis.getBuyAmount.call(WETH, DAI, web3.utils.toWei('1'));
            console.log('returnAmount', returnAmount.toString() / 1e18);
        });

        it('should work getBuyAmount WETH => cETH', async function () {
            const returnAmount = await this.multiOasis.getBuyAmount.call(WETH, cETH, web3.utils.toWei('1'));
            console.log('returnAmount', returnAmount.toString() / 1e18);
        });

        it('should work getBuyAmount cDAI => DAI', async function () {
            const returnAmount = await this.multiOasis.getBuyAmount.call(cDAI, DAI, '100000000');
            console.log('returnAmount', returnAmount.toString() / 1e8);
        });

        it('should work getBuyAmount cETH => cDAI', async function () {
            const returnAmount = await this.multiOasis.getBuyAmount.call(cETH, cDAI, '100000000');
            console.log('returnAmount', returnAmount.toString() / 1e8);
        });

        it('should work getExpectedRate WETH => DAI', async function () {
            const returnAmount = await this.multiOasis.getBuyAmount.call(WETH, DAI, web3.utils.toWei('1'));
            console.log('returnAmount', returnAmount.toString() / 1e18);
        });

        it('should work getExpectedRate DAI => WETH', async function () {
            const returnAmount = await this.multiOasis.getBuyAmount.call(DAI, WETH, web3.utils.toWei('1'));
            console.log('returnAmount', returnAmount.toString() / 1e18);
        });

        it('should work getExpectedRate WETH => cETH', async function () {
            const returnAmount = await this.multiOasis.getBuyAmount.call(WETH, cETH, web3.utils.toWei('1'));
            console.log('returnAmount', returnAmount.toString() / 1e18);
        });
    });
});
