def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

#FILL YOUR CODE HERE
# parse_dns method to parse the data present in zone file
def parse_dns(dns_raw)
  dns_records = {}
  dns_raw.each do |dns|
    dns = dns.split(",").join(" ")
    #dns = dns.split(" ")
    if dns.split.first == "A" || dns.split.first == "CNAME"
      dns_records[dns.split[1]] = { type: dns.split[0], target: dns.split[2] 
    end
  end
  return dns_records
end

#resolve function
def resolve(dns_records, lookup_chain, domain)
  if dns_records[domain][:type] == "A"
    lookup_chain.push(dns_records[domain][:target])
  elsif dns_records[domain][:type] == "CNAME"
    lookup_chain.push(dns_records[domain][:target])
    resolve(dns_records, lookup_chain, dns_records[domain][:target])
  end
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
if (dns_records.has_key?(domain))
  lookup_chain = resolve(dns_records, lookup_chain, domain)
  puts lookup_chain.join(" => ")
else
  puts "Error: record not found for #{domain}"
end
