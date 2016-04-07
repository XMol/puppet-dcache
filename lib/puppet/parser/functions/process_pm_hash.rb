module Puppet::Parser::Functions
  newfunction(:process_pm_hash, :type => :rvalue) do |args|
    units = {
      'store'    => Array.new,
      'net'      => Array.new,
      'protocol' => Array.new,
      'dcache'   => Array.new,
    }
    ugroups = Hash.new({})
    pools = Array.new
    pgroups = Hash.new({})
    links = Hash.new({})
    lgroups = Hash.new({})

    # Update the collection of units by adding them to each
    # unit class. Make also sure that the list of units
    # doesn't contain duplicates.
    # We have to define this method in this ugly way, because otherwise
    # units is not in the scope of the method (Google "Ruby scope gates").
    Kernel.send(:define_method, :new_units) do |uhash|
      uhash.each do |key, val|
        units[key] += val
        units[key].uniq!
      end
    end

    # For each new unit group add all units to the respective list of its
    # kind. Keep a map of ugroup name to all its units in the ugroups hash.
    Kernel.send(:define_method, :new_ugroup) do |ugroup, uhash|
      ugroups[ugroup] = uhash.values.flatten
      new_units(uhash)
    end

    # For each new pool group, add all pools to the list of all pools.
    Kernel.send(:define_method, :new_pgroup) do |pgroup, plist|
      pgroups[pgroup] = plist
      pools += plist
      pools.uniq!
    end

    # links are broken down into three subparts:
    #   - ugroups
    #     Add every ugroup from this link to the hash of all ugroups. Keep
    #     a list of all ugroups (w/o their respective units).
    #   - pgroups
    #     Update the hash of all pgroups. Keep a list of pgroups.
    #   - prefs
    #     Only the link itself needs to now whether preferences were set.
    Kernel.send(:define_method, :new_link) do |link, lhash|
      my_link = {
        'ugroups' => [],
        'pgroups' => [],
        'prefs'   => {
          'read'  => 0,
          'write' => 0,
          'cache' => 0,
          'p2p'   => 0,
        },
      }
    
      if lhash.key?('ugroups')
        lhash['ugroups'].each do |ugroup, uhash|
          new_ugroup(ugroup, uhash)
          my_link['ugroups'] << ugroup
        end
        my_link['ugroups'].uniq!
      end
    
      if lhash.key?('pgroups')
        lhash['pgroups'].each do |pgroup, plist|
          new_pgroup(pgroup, plist)
          my_link['pgroups'] << pgroup
        end
        my_link['pgroups'].uniq!
      end
      
      my_link['prefs'].merge!(lhash.fetch('prefs', {}))
      
      links[link] = my_link
    end

    Kernel.send(:define_method, :new_lgroup) do |lgroup, lghash|
      my_lgroup = {
        'allowances' => {
          'online'    => false,
          'nearline'  => false,
          'replica'   => false,
          'custodial' => false,
          'output'    => false,
        },
        'links' => Array.new(),
      }
      
      my_lgroup['allowances'].merge!(lghash.fetch('allowances', {}))
      
      if lghash.key?('links')
        lghash['links'].each do |link, lhash|
          new_link(link, lhash)
          my_lgroup['links'] << link
        end
        my_lgroup['links'].uniq!
      end
      
      lgroups[lgroup] = my_lgroup
    end

    args[0].each do |pm_class, members|
      case pm_class
      when 'units'
        new_units(members)
      when 'ugroups'
        members.each do |ugroup, uhash|
          new_ugroup(ugroup, uhash)
        end
      when 'pools'
        pools += members
        pools.uniq!
      when 'pgroups'
        members.each do |pgroup, plist|
          new_pgroup(pgroup, plist)
        end
      when 'links'
        members.each do |link, lhash|
          new_link(link, lhash)
        end
      when 'lgroups'
        members.each do |lgroup, lghash|
          new_lgroup(lgroup, lghash)
        end
      end
    end
    
    return {
      'units'   => units,
      'ugroups' => ugroups,
      'pools'   => pools,
      'pgroups' => pgroups,
      'links'   => links,
      'lgroups' => lgroups, 
    }
  end
end
