#!/usr/bin/env ruby

def make_once
  `makepkg 2>&1`.split(/\n/).map!{|ln| ln.chomp}
end

def pac_depends(list)
  `sudo pacman -Sy --noconfirm --needed #{list.join(' ')}`
end

depends  = []
result   = make_once
retry_ct = 0

# warn result;nil

result.each do |ln|
  /ERROR/ =~ ln ? (puts 'Error detected, checking dependencies'; retry_ct += 1) : ()
  /->/    =~ ln ? depends.append(ln.split(/\s/).last) : ()
end

# warn depends;nil

retry_ct > 0 ? pac_depends(depends) : ()
