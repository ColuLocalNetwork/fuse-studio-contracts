const MembersList = artifacts.require('MembersList')

module.exports = function (deployer) {
  deployer.deploy(MembersList)
}
