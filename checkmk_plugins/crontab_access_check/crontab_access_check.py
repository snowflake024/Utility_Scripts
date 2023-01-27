#!/usr/bin/env python3

from .agent_based_api.v1 import *


def discover_crontab_access_check(section):
    yield Service()


def check_crontab_access(section):
    for line in section:
        if line[0].startswith("Failed-CRON"):
            yield Result(state=State.CRIT, summary="Local user oracle cannot access crontab")
            return
    # Keep in mind that the bash script on agent side needs to be adapted for whichever user,
    # needs to be checked against access to its own crontab
    yield Result(state=State.OK, summary="Local user cannot access to crontab is OK")


register.check_plugin(
    name="crontab_access_check",
    service_name="Crontab Access Checker",
    discovery_function=discover_crontab_access_check,
    check_function=check_crontab_access,
)
