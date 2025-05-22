# Transform the psu input data into fully qualified information about all
# entities relevant to the Pool Selection Unit.
Puppet::Functions.create_function(:'dcache::hash_to_psu') do

  local_types do
    type 'Units = Struct[{
      Optional[store]    => Array[String],
      Optional[net]      => Array[String],
      Optional[protocol] => Array[String],
      Optional[dcache]   => Array[String],
    }]'
    # Lists of pools may be nested arbitrarily deep within other lists
    type 'Pgroup = Array[Variant[String, Pgroup]]'
    type 'InputLink = Struct[{
      Optional[ugroups]   => Hash[String, Units],
      Optional[pgroups]   => Hash[String, Pgroup],
      Optional[prefs]     => Struct[{
        Optional[read]    => Integer[0],
        Optional[write]   => Integer[0],
        Optional[cache]   => Integer[0],
        Optional[p2p]     => Integer,
        Optional[section] => String,
      }]
    }]'
    type 'OutputLink = Struct[{
      Optional[ugroups]   => Array[String],
      Optional[pgroups]   => Array[String],
      Optional[prefs]     => Struct[{
        Optional[read]    => Integer[0],
        Optional[write]   => Integer[0],
        Optional[cache]   => Integer[0],
        Optional[p2p]     => Integer,
        Optional[section] => String,
      }]
    }]'
    type 'InputLgroup = Struct[{
      Optional[allowances] => Struct[{
        Optional[online]    => Boolean,
        Optional[nearline]  => Boolean,
        Optional[replica]   => Boolean,
        Optional[custodial] => Boolean,
        Optional[output]    => Boolean,
      }],
      Optional[links]      => Hash[String, InputLink],
    }]'
    type 'OutputLgroup = Struct[{
      Optional[allowances] => Struct[{
        Optional[online]    => Boolean,
        Optional[nearline]  => Boolean,
        Optional[replica]   => Boolean,
        Optional[custodial] => Boolean,
        Optional[output]    => Boolean,
      }],
      Optional[links]      => Array[String],
    }]'
  end

  # @param content
  #   The streamlined input data.
  # @return [Struct]
  #   Transformed, extensive and fully qualified data for PoolManager.
  dispatch :main do
    param 'Struct[{
      Optional[units]   => Units,
      Optional[ugroups] => Hash[String, Units],
      Optional[pools]   => Array[String],
      Optional[pgroups] => Hash[String, Pgroup],
      Optional[links]   => Hash[String, InputLink],
      Optional[lgroups] => Hash[String, InputLgroup],
    }]', :content
    return_type 'Struct[{
      units   => Units,
      ugroups => Hash[String, Array[String]],
      pools   => Array[String],
      pgroups => Hash[String, Array[String]],
      links   => Hash[String, OutputLink],
      lgroups => Hash[String, OutputLgroup],
    }]'
  end

  def main (content)
    all_units = {
      'store'    => Array.new(),
      'net'      => Array.new(),
      'protocol' => Array.new(),
      'dcache'   => Array.new(),
    }
    all_ugroups = Hash.new({})
    all_pools = Array.new()
    all_pgroups = Hash.new({})
    all_links = Hash.new({})
    all_lgroups = Hash.new({})

    # Implement deep merging with lambdas, as to not break scope.
    new_units = ->(units) {
      units.each do |key, val|
        all_units[key] += val
      end
    }

    # For each new unit group add all units to the respective list of its
    # kind. Keep a map of ugroup name to all its units in the ugroups hash.
    new_ugroup = ->(ugroup, uhash) {
      all_ugroups[ugroup] = uhash.values
      new_units.call(uhash)
    }

    # For each new pool group, add all pools to the list of all pools.
    new_pgroup = ->(pgroup, plist) {
      all_pgroups[pgroup] = plist
      all_pools += plist.flatten.delete_if { |p| p.start_with?('@') }
    }

    # links are broken down into three subparts:
    #   - ugroups
    #     Add every ugroup from this link to the hash of all ugroups. Keep
    #     a list of all ugroups (w/o their respective units).
    #   - pgroups
    #     Update the hash of all pgroups. Keep a list of pgroups.
    #   - prefs
    #     Only the link itself needs to now whether preferences were set.
    new_link = ->(link, lhash) {
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
          new_ugroup.call(ugroup, uhash)
          my_link['ugroups'] << ugroup
        end
      end

      if lhash.key?('pgroups')
        lhash['pgroups'].each do |pgroup, plist|
          new_pgroup.call(pgroup, plist)
          my_link['pgroups'] << pgroup
        end
      end

      my_link['prefs'].merge!(lhash.fetch('prefs', {}))

      my_link['section'] = lhash['section'] if lhash.key?('section')

      all_links[link] = my_link
    }

    new_lgroup = ->(lgroup, lghash) {
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
          new_link.call(link, lhash)
          my_lgroup['links'] << link
        end
      end

      all_lgroups[lgroup] = my_lgroup
    }

    content.each do |pm_class, members|
      case pm_class
      when 'units'
        new_units.call(members)
      when 'ugroups'
        members.each do |ugroup, uhash|
          new_ugroup.call(ugroup, uhash)
        end
      when 'pools'
        pools += members
      when 'pgroups'
        members.each do |pgroup, plist|
          new_pgroup.call(pgroup, plist)
        end
      when 'links'
        members.each do |link, lhash|
          new_link.call(link, lhash)
        end
      when 'lgroups'
        members.each do |lgroup, lghash|
          new_lgroup.call(lgroup, lghash)
        end
      end
    end

    # Flatten and uniq all lists.
    all_units.each_value do |us|
      us.flatten!
      us.uniq!
    end
    all_ugroups.each_value do |ugs|
      ugs.flatten!
      ugs.uniq!
    end
    all_pools.flatten!
    all_pools.uniq!
    all_pgroups.each_value do |pgs|
      pgs.flatten!
      pgs.uniq!
    end
    # Add "all-pools" pool group explicitly
    all_pgroups['all-pools'] = all_pools

    return {
      'units'   => all_units,
      'ugroups' => all_ugroups,
      'pools'   => all_pools,
      'pgroups' => all_pgroups,
      'links'   => all_links,
      'lgroups' => all_lgroups,
    }
  end
end
