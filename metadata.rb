name             "twistd"
maintainer       "Ying Li"
maintainer_email "cyli@twistedmatrix.com"
license          "MIT"
description      "Installs twisted and sets up twistd services as resources"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

supports         "ubuntu", ">= 9.10"
recommends       "authbind"

provides         "twistd_plugin"
provides         "twistd_web"
provides         "twistd_dns"
provides         "twistd::default"

recipe           "twistd::default", "Installs twisted"
