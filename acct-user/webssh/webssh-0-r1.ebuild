# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="WebSSH user"
ACCT_USER_ID=922
ACCT_USER_GROUPS=( webssh )

acct-user_add_deps
