#!/usr/bin/env python3

from .agent_based_api.v1 import *


def discover_crontab_access_check(section):
    yield Service()


def check_user(section):
    for line in section:
        if line.startswith('user', 8):
            return line[13:]


# Keep in mind that the bash script on agent side needs to be adapted for whichever user,
# needs to be checked against access to its own crontab
def check_crontab_access(section):
    for line in section:
        if line[1].startswith("Failed-CRON"):
            yield Result(state=State.CRIT, summary=f"Local user {check_user(section)} cannot access crontab")
            return
    yield Result(state=State.OK, summary=f"Local user {check_user(section)} cannot access to crontab is OK")


register.check_plugin(
    name="crontab_access_check",
    service_name="Crontab Access Checker",
    discovery_function=discover_crontab_access_check,
    check_function=check_crontab_access,
)
