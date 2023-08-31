import pytest


MAX_BPS = 10_000


@pytest.fixture(scope="module")
def common_health_check(gov, CommonHealthCheck):
    yield gov.deploy(CommonHealthCheck)


def test_set_goverance(gov, rando, common_health_check):
    with pytest.raises(ValueError, match="execution reverted"):
       common_health_check.setGovernance(rando, {"from": rando})
    common_health_check.setGovernance(rando, {"from": gov})


@pytest.mark.ci
def test_set_management(gov, rando, common_health_check):
    common_health_check.setManagement(rando, {"from": gov})


@pytest.mark.ci
def test_set_profit_limit_ratio(gov, rando, common_health_check):
    common_health_check.setProfitLimitRatio(10, {"from": gov})


@pytest.mark.ci
def test_set_stop_loss_limit_ratio(gov, rando, common_health_check):
    common_health_check.setlossLimitRatio(10, {"from": gov})


@pytest.mark.ci
def test_set_strategy_limit(gov, rando, regular_strategy, common_health_check):
    common_health_check.setStrategyLimits(regular_strategy, 10, 10, {"from": gov})


def test_set_set_check(gov, rando, strategy, common_health_check):
    common_health_check.setCheck(strategy, strategy, {"from": gov})
