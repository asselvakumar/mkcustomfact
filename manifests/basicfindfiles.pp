# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include mkcustomfact::basicfindfiles
class mkcustomfact::basicfindfiles {
    $testhost = find_file('/etc/hosts')
#    notify {"Host file is in [${testhost}]":}
    $tmpfile = find_file('/tmp/check/elastic_agent_install.sh')
#    notify {"Temp file script exists in [${tmpfile}] with side helping of [${testhost}]":}
    $loclscript = find_file('/usr/local/bin/elastic_agent_install.sh')
#    notify {"Local script exists in [${loclscript}] with side helping of [${testhost}]":}
}
