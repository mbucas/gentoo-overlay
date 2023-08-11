# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="guacd user"
ACCT_USER_ID=911
ACCT_USER_GROUPS=( guacd )

acct-user_add_deps
