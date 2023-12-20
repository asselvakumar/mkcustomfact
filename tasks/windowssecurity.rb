#!/bin/sh

# Puppet Task Name: windowssecurity
#
# This is where you put the shell code for your task.
#
# You can write Puppet tasks in any language you want and it's easy to
# adapt an existing Python, PowerShell, Ruby, etc. script. Learn more at:
# https://puppet.com/docs/bolt/0.x/writing_tasks.html
#
# Puppet tasks make it easy for you to enable others to use your script. Tasks
# describe what it does, explains parameters and which are required or optional,
# as well as validates parameter type. For examples, if parameter "instances"
# must be an integer and the optional "datacenter" parameter must be one of
# portland, sydney, belfast or singapore then the .json file
# would include:
#   "parameters": {
#     "instances": {
#       "description": "Number of instances to create",
#       "type": "Integer"
#     },
#     "datacenter": {
#       "description": "Datacenter where instances will be created",
#       "type": "Enum[portland, sydney, belfast, singapore]"
#     }
#   }
# Learn more at: https://puppet.com/docs/bolt/0.x/writing_tasks.html#ariaid-title11
#

#!/opt/puppetlabs/puppet/bin/ruby
require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'open3'

def grp(patchgroup,emailaddress)

#Declaration
puppetdb_facts_endpoint = "http://localhost:8080/pdb/query/v4/facts"
puppetdb_uri = URI.parse(puppetdb_facts_endpoint)
puppetdb_query = {:query => '["=",["fact", "osfamily"], "windows"]'}

#curl -X GET http://localhost:8080/pdb/query/v4/facts --data-urlencode 'query=["=",["fact", "osfamily"], "windows"]'


puppetdb_uri.query = URI.encode_www_form(puppetdb_query)
puppetdb_reports = Net::HTTP.get_response(puppetdb_uri)
puppetdb_reports_json = JSON.parse(puppetdb_reports.body)
time = Time.now
date = time.strftime("%m-%d-%Y %H:%M:%S")
#patchgroup = "NEC"

path_file = "/tmp/#{patchgroup}-Windows_Security_Review.htm"
path_file_csv = "/tmp/#{patchgroup}-Windows_Security_Review.csv"

from = "no_reply_svr-puppet-01@nec.com.sg"
realname = "No Reply Puppet"
subject = "#{patchgroup} - Windows Security Review"
#emailaddress = "davidmarklester_l@nec.com.sg"

#html Creation
puppet_report_html = File.open("#{path_file}","w")
#CSV Creation
puppet_report_csv = File.open("#{path_file_csv}","w")
puppet_report_csv.write("HostName,System,Network Zone,Account Name,Enabled,Membership,Last Login Date,Days Since Last Login,Password Last Set,Password Expires,Status\n")

#CSS
puppet_report_html.write("<head>")
puppet_report_html.write("<style>")
puppet_report_html.write("body {font-family: 'Arial';font-size: 8pt;color: #4C607B;}")
puppet_report_html.write("th, td {border: 1px solid #e57300; border-collapse: collapse; padding: 5px;}")
puppet_report_html.write("th {font-size: 8pt;text-align: Center;background-color: #003366;color: #ffffff;}")
puppet_report_html.write("h1 {width: 100%;background-color: Black;font-family: 'Arial';}")
puppet_report_html.write("h2 {width: 100%;background-color: Brown;font-family: 'Arial';text-align: Center;color: white;}")
puppet_report_html.write("h5 { width: 100%;font-family: 'Arial';text-align: Center;color: Black;}")      
puppet_report_html.write("table {width: 100%;}")
puppet_report_html.write("td {color: white;background-color: Green;text-align: Center;font-size: 8pt;}")
puppet_report_html.write(".even { background-color: #ffffff; }")
puppet_report_html.write(".odd { background-color: #bfbfbf; }")
puppet_report_html.write("</style>")
puppet_report_html.write("</head><body>")

puppet_report_html.write("<font color='White' font Size= '4'><h1 align = 'Center'>[#{patchgroup}] Windows Security Review</h1></font>")
puppet_report_html.write("<h5>Updated: on #{date}</h5>")
puppet_report_html.write("<h2 align = 'Center'>Local Accounts</h2>")
puppet_report_html.write("<table align = 'Center'>")
puppet_report_html.write("<colgroup><col/><col/><col/><col/><col/><col/><col/><col/><col/><col/></colgroup>")
puppet_report_html.write("<tr><th>HostName</th><th>System</th><th>Network Zone</th><th>Account Name</th><th>Enabled</th><th>Membership</th><th>Last Login Date</th><th>Days since Last Login</th><th>Password Last Set</th><th>Password Expires</th><th>Status</th></tr>")

puppetdb_reports_json.each do |report|
        if report['name'] == 'clientcert'
                hostname = report['value']

                grouping = puppetdb_reports_json.find {|details| details['certname']==(hostname) and details['name']=='pe_patch'}['value']['patch_group']
                if grouping == "#{patchgroup}"        
                        #patch group
                        patch_group =  puppetdb_reports_json.find {|details| details['certname']==(hostname) and details['name']=='pe_patch'}['value']['patch_group']	
                        #hostname
                        hname = puppetdb_reports_json.find {|details| details['certname']==(hostname) and details['name']=='hostname'}['value']
                        #Network_Zone
                        network_zone = puppetdb_reports_json.find {|details| details['certname']==(hostname) and details['name']=='network_zone'}['value']	
                        #Uptime
                        uptime = puppetdb_reports_json.find {|details| details['certname']==(hostname) and details['name']=='uptime_days'}['value']
                        
			localaccounts = puppetdb_reports_json.find {|details| details['certname']==(hostname) and details['name']=='localaccounts'}['value']
			localaccounts.each do |k,v|
                                accountname = k
                                dayslastlogon = v['dayslastlogon']
                                enabled = v['enabled']
				lastLogon = v['lastLogon']
				membership = v['membership']
				passwordexpires = v['passwordexpires']
				passwordlastset = v['passwordlastset']
				status = v['status']


			puppet_report_csv.write("#{hname},#{patch_group},#{network_zone},#{accountname},#{enabled},#{membership},#{lastLogon},#{dayslastlogon},#{passwordexpires},#{passwordlastset},#{status}\n")			
                        #HTML Entry
                        puppet_report_html.write("<tr>")
                        puppet_report_html.write("<td style='background-color:Teal'>#{hname}</td>")
                        puppet_report_html.write("<td style='background-color:Teal'>#{patch_group}</td>")
                        puppet_report_html.write("<td style='background-color:Teal'>#{network_zone}</td>")
                        puppet_report_html.write("<td style='background-color:Green'>#{accountname}</td>")
			puppet_report_html.write("<td style='background-color:Green'>#{enabled}</td>")
			puppet_report_html.write("<td style='background-color:Green'>#{membership}</td>")
			puppet_report_html.write("<td style='background-color:Green'>#{lastLogon}</td>")
			puppet_report_html.write("<td style='background-color:Green'>#{dayslastlogon}</td>")
			puppet_report_html.write("<td style='background-color:Green'>#{passwordexpires}</td>")
			puppet_report_html.write("<td style='background-color:Green'>#{passwordlastset}</td>")
			puppet_report_html.write("<td style='background-color:Green'>#{status}</td>")
			puppet_report_html.write("</tr>")
			
			end
                end
        end
end
puppet_report_html.write("</table>")

puppet_report_html.close
puppet_report_csv.close
cmd = "echo "" | mutt -e 'set content_type=text/html from=\"#{from}\" realname=\"#{realname}\"' -s \"#{subject}\" #{emailaddress} -a #{path_file_csv}"
system(cmd)

end

params = JSON.parse(STDIN.read)
patchgroup = params['patchgroup']
emailaddress = params['emailaddress']

grp "#{patchgroup}","#{emailaddress}"

