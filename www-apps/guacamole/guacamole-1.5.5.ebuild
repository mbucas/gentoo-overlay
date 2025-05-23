# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2
DESCRIPTION="Guacamole is a html5 vnc client as servlet"
HOMEPAGE="https://guacamole.apache.org/"
SRC_URI="http://mirrors.ircam.fr/pub/apache/guacamole/${PV}/source/guacamole-client-${PV}.tar.gz"
S="${WORKDIR}/${PN}-client-${PV}"

LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64"

IUSE="ldap mysql noauth postgres"

REQUIRED_USE="|| ( ldap mysql noauth postgres )"

DEPEND="
	virtual/jdk:11
	dev-java/maven-bin:*"

RDEPEND="${DEPEND}
	www-servers/tomcat:9
	virtual/jre:11
	net-misc/guacamole-server
	mysql? ( virtual/mysql dev-java/jdbc-mysql )
	postgres? ( dev-db/postgresql dev-java/jdbc-postgresql )
	ldap? ( net-nds/openldap )"

# To enable Maven access to https://repo.maven.apache.org/maven2
RESTRICT="network-sandbox"

src_prepare() {
	cp "${FILESDIR}"/${PF}-maven-settings.xml "${S}"/settings.xml
	default
}

src_compile() {
	mvn -s "${S}"/settings.xml package || die
}

src_install() {
	EXTENSIONS="${WORKDIR}/${PN}-client-${PV}/extensions"
	#echo guacd-hostname: localhost >>"${S}/${PN}/doc/example/${PN}.properties"
	#echo guacd-port:     4822 >>"${S}/${PN}/doc/example/${PN}.properties"
	#echo basic-user-mapping: /etc/guacamole/user-mapping.xml >>"${S}/${PN}/doc/example/${PN}.properties"
	if use mysql || use postgres; then
		insinto "/etc/${PN}/extensions"
		find "${EXTENSIONS}/${PN}-auth-jdbc/modules/${PN}-auth-jdbc-base/" -name '*.jar' -exec doins '{}' +
	fi
	if use noauth; then
		#sed -e 's:basic-user-mapping:#basic-user-mapping:' -i "${S}/${PN}/doc/example/${PN}.properties"
		#echo noauth-config: /etc/guacamole/noauth-config.xml  >>"${S}/${PN}/doc/example/${PN}.properties"
		insinto "/etc/${PN}/extensions"
		find "${EXTENSIONS}/${PN}-auth-noauth/" -name '*.jar' -exec doins '{}' +
		insinto "/etc/guacamole"
		find "${EXTENSIONS}/${PN}-auth-noauth/doc/example/" -name '*.xml' -exec doins '{}' +
		elog "Warning: Setting No Authentication is obviously very insecure! Only use it if you know what you are doing!"
	fi
	if use mysql; then
		#echo mysql-hostname: localhost >>"${S}/${PN}/doc/example/${PN}.properties"
		#echo mysql-port: 3306 >>"${S}/${PN}/doc/example/${PN}.properties"
		#echo mysql-database: guacamole >>"${S}/${PN}/doc/example/${PN}.properties"
		#echo mysql-username: guacamole >>"${S}/${PN}/doc/example/${PN}.properties"
		#echo mysql-password: some_password >>"${S}/${PN}/doc/example/${PN}.properties"
		#sed -e 's:basic-user-mapping:#basic-user-mapping:' -i "${S}/${PN}/doc/example/${PN}.properties"
		insinto "/etc/${PN}/extensions"
		find "${EXTENSIONS}/${PN}-auth-jdbc/modules/${PN}-auth-jdbc-mysql/" -name '*.jar' -exec doins '{}' +
		insinto "/usr/share/${PN}/schema/mysql"
		find "${EXTENSIONS}/${PN}-auth-jdbc/modules/${PN}-auth-jdbc-mysql/schema/" -name '*.sql' -exec doins '{}' +
		elog "Please add a mysql database and a user and load the sql files in /usr/share/guacamole/schema/ into it."
		elog "If this is an update, then you will need to apply the appropriate update script in the location above."
		elog "You will also need to adjust the DB properties in /etc/guacamole.properties!"
		elog "The default user and it's password is \"guacadmin\"."
		elog "You also have to enable jdbc-mysql in tomcat!"
		elog "For tomcat under openrc this can be done in /etc/conf.d/tomcat-7 with TOMCAT_EXTRA_JARS=jdbc-mysql"
		elog "Another way is to add /usr/share/jdbc-mysql/lib/jdbc-mysql.jar to the classpath."
		elog "-"
	fi
	if use postgres; then
		#echo postgresql-hostname: localhost >>"${S}/${PN}/doc/example/${PN}.properties"
		#echo postgresql-port: 5432 >>"${S}/${PN}/doc/example/${PN}.properties"
		#echo postgresql-database: guacamole >>"${S}/${PN}/doc/example/${PN}.properties"
		#echo postgresql-username: guacamole >>"${S}/${PN}/doc/example/${PN}.properties"
		#echo postgresql-password: some_password >>"${S}/${PN}/doc/example/${PN}.properties"
		#sed -e 's:basic-user-mapping:#basic-user-mapping:' -i "${S}/${PN}/doc/example/${PN}.properties"
		insinto "/etc/${PN}/extensions"
		find "${EXTENSIONS}/${PN}-auth-jdbc/modules/${PN}-auth-jdbc-postgresql/" -name '*.jar' -exec doins '{}' +
		insinto "/usr/share/${PN}/schema/postgres"
		find "${EXTENSIONS}/${PN}-auth-jdbc/modules/${PN}-auth-jdbc-postgresql/schema/" -name '*.sql' -exec doins '{}' +
		elog "Please add a postgresql database and a user and load the sql files in /usr/share/guacamole/schema/ into it."
		elog "If this is an update, then you will need to apply the appropriate update script in the location above."
		elog "You will also need to adjust the DB properties in /etc/guacamole.properties!"
		elog "The default user and it's password is \"guacadmin\"."
		elog "You also have to enable jdbc-postgresql in tomcat!"
		elog "For tomcat under openrc this can be done in /etc/conf.d/tomcat-7 with TOMCAT_EXTRA_JARS=jdbc-postgresql"
		elog "Another way is to add /usr/share/jdbc-postgresql/lib/jdbc-postgresql.jar to the classpath."
		elog "-"
	fi
	if use ldap; then
		#echo ldap-hostname: localhost >>"${S}/${PN}/doc/example/${PN}.properties"
		#echo ldap-port: 389 >>"${S}/${PN}/doc/example/${PN}.properties"
		#echo ldap-user-base-dn: ou=people,dc=example,dc=net >>"${S}/${PN}/doc/example/${PN}.properties"
		#echo ldap-username-attribute: uid >>"${S}/${PN}/doc/example/${PN}.properties"
		#echo ldap-config-base-dn: ou=groups,dc=example,dc=net >>"${S}/${PN}/doc/example/${PN}.properties"
		#sed -e 's:basic-user-mapping:#basic-user-mapping:' -i "${S}/${PN}/doc/example/${PN}.properties"
		insinto "/etc/${PN}/extensions"
		find "${EXTENSIONS}/${PN}-auth-ldap" -name '*.jar' -exec doins '{}' +
		insinto "/usr/share/${PN}/schema"
		doins "${EXTENSIONS}/${PN}-auth-ldap/schema/guacConfigGroup.ldif"
		doins "${EXTENSIONS}/${PN}-auth-ldap/schema/guacConfigGroup.schema"
		elog "You will need to add and load the .schema file in /usr/share/guacamole/schema/ to your ldap server."
		elog "There is also an example .lidf file for creating the users."
		elog "-"
	fi
	insinto "/etc/${PN}"
	doins "${WORKDIR}/${PN}-client-${PV}/${PN}/doc/example/user-mapping.xml"
	#insinto "/etc/${PN}"
	#doins "${S}/${PN}/doc/example/guacamole.properties"
	echo "GUACAMOLE_HOME=/etc/guacamole" >98guacamole
	doenvd 98guacamole
	insinto "/var/lib/${PN}"
	newins "${S}/${PN}/target/${P}.war" "${PN}.war"
	elog "If it is an update, please make sure to delete the old webapp in /var/lib/tomcat-8/webapps/ first!"
	elog "To deploy guacamole with tomcat, you will need to link the war file and create the configuration!"
	elog "ln -sf /var/lib/${PN}/${PN}.war /var/lib/tomcat-8/webapps/"
	elog "You will also need to adjust the configuration in /etc/${PN}/${PN}.properties"
	elog "With systemd make sure that the var GUACAMOLE_HOME is set to /etc/guacamole. for example via /etc/conf/tomcat."
	elog "See http://guac-dev.org/doc/${PV}/gug/configuring-guacamole.html#initial-setup for a basic setup"
	elog "or http://guac-dev.org/doc/${PV}/gug/jdbc-auth.html for a database for authentication and host definitions."
}
