#!/bin/env bash
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#	 author: Ángel Guzmán Maeso <angel.guzman@alu.uclm.es>
#
#    Create the php docs for all .php files involved on FreeStation
#

# Requires:
#   - PHP >= 5.2.6
#   - iconv/ext (enabled by default since PHP 5.0.0)
#   - XSL extension
#   - Graphviz (optional, used for generating Class diagrams)
#   - PEAR (optional, used for generating Class Diagrams or installing via PEAR)

DOCBLOX_BINARY='phpdoc/bin/phpdoc.php'

# The HyperVM source path to generate the php-doc
APP_SOURCE_PATH='.' 

# The HyperVM documentation path to output the php-doc
APP_DOC_PATH='./doc'

DOCBLOX_CONFIGURATION_FILE='phpdoc.dist.xml'

usage(){
    echo 'Usage: $0 [-h]'
    echo 'h: shows this help.'
    exit 1
}

install_GIT()
{
	# Redhat based
	if [ -f /etc/redhat-release ] ; then
		# Install git with curl and expat support to enable support on github cloning
		yum install gettext-devel expat-devel curl-devel zlib-devel openssl-devel
	# Debian based
	elif [ -f /etc/debian_version ] ; then
		# Needed XSLTProcessor
		apt-get install php5 php5-xsl
	fi

	# @todo Try to get the lastest version from some site. LASTEST file?
	GIT_VERSION='1.7.9.1'

	echo "Downloading and compiling GIT ${GIT_VERSION}"
	wget http://git-core.googlecode.com/files/git-${GIT_VERSION}.tar.gz
	tar xvfz git-*.tar.gz; cd git-*;
	./configure --prefix=/usr --with-curl --with-expat
	make all
	make install

	echo 'Cleaning GIT files.'
	cd ..; rm -rf git-*
}

if [ `/usr/bin/id -u` -ne 0 ]; then
    echo 'Please, run this script as root.'
    usage
fi

if [ ! -d "phpdoc" ]; then
	echo 'Installing docblox.'

	if which git >/dev/null; then
		echo 'GIT support detected.'
	else
	    echo 'No GIT support detected. Installing GIT.'
	    install_GIT
	fi
github.com/phpDocumentor/phpDocumentor2
	# Clone from GitHub the last version using git transport (no http or https)
	git clone git://github.com/phpDocumentor/phpDocumentor2.git phpdoc

	# Install the new_black theme as default
	sudo chmod +x $DOCBLOX_BINARY
	php $PHPDOC_BINARY template:install new_black -v 1.0.1
fi

# Generate the php-doc
echo 'Generating the doc files. It could take around 180 sec or more. Be patient'
php $PHPDOC_BINARY run -c $PHPDOC_CONFIGURATION_FILE -d $APP_SOURCE_PATH -t $APP_DOC_PATH