const Migrations = artifacts.require('./Migrations.sol');
const MultiKyber = artifacts.require('./MultiKyber.sol');

module.exports = function (deployer) {
    deployer.deploy(Migrations);
    deployer.deploy(
        MultiKyber,
        '0x0000000000000000000000000000000000000000',
        '0x0000000000000000000000000000000000000000',
        '0x0000000000000000000000000000000000000000',
    );
};
