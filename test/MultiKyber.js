// const { expectRevert } = require('openzeppelin-test-helpers');
// const { expect } = require('chai');

const MultiKyber = artifacts.require('MultiKyber');

const KyberAddress = '0x818E6FECD516Ecc3849DAf6845e3EC868087B755';
const CompoundComptroller = '0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B';

const ETH = '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE';
const DAI = '0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359';
const cETH = '0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5';
const cDAI = '0xF5DCe57282A584D2746FaF1593d3121Fcac444dC';
const WETH = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2';

contract('MultiKyber', function ([_, addr1]) {
    describe('MultiKyber', async function () {
        before(async function () {
            this.multiKyber = await MultiKyber.new(
                KyberAddress,
                CompoundComptroller,
                cETH,
            );
        });

        it('should work getExpectedRate ETH => DAI', async function () {
            const { expectedRate } = await this.multiKyber.getExpectedRate.call(ETH, DAI, web3.utils.toWei('1'));
            console.log('expectedRate', expectedRate.toString() / 1e18);
        });

        it('should work getExpectedRate ETH => cETH', async function () {
            const { expectedRate } = await this.multiKyber.getExpectedRate.call(ETH, cETH, web3.utils.toWei('1'));
            console.log('expectedRate', expectedRate.toString() / 1e18);
        });

        it('should work getExpectedRate cDAI => DAI', async function () {
            const { expectedRate } = await this.multiKyber.getExpectedRate.call(cDAI, DAI, '100000000');
            console.log('expectedRate', expectedRate.toString() / 1e18);
        });

        it('should work getExpectedRate cETH => cDAI', async function () {
            const { expectedRate } = await this.multiKyber.getExpectedRate.call(cETH, cDAI, '100000000');
            console.log('expectedRate', expectedRate.toString() / 1e18);
        });

        it('should work getExpectedRate WETH => DAI', async function () {
            const { expectedRate } = await this.multiKyber.getExpectedRate.call(WETH, DAI, web3.utils.toWei('1'));
            console.log('expectedRate', expectedRate.toString() / 1e18);
        });

        it('should work getExpectedRate DAI => WETH', async function () {
            const { expectedRate } = await this.multiKyber.getExpectedRate.call(DAI, WETH, web3.utils.toWei('1'));
            console.log('expectedRate', expectedRate.toString() / 1e18);
        });

        it('should work getExpectedRate WETH => cETH', async function () {
            const { expectedRate } = await this.multiKyber.getExpectedRate.call(WETH, cETH, web3.utils.toWei('1'));
            console.log('expectedRate', expectedRate.toString() / 1e18);
        });
    });
});
