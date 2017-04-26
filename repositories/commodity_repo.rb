require 'rom-repository'

class CommodityRepo < ROM::Repository[:commodities]
  def commodity_groups_for_select
    DB.base['SELECT id, commodity_group_code, commodity_group_description FROM commodity_groups ORDER BY commodity_group_code'].map {|r| ["#{r[:commodity_group_code]} - #{r[:commodity_group_description]}", r[:id]] }
  end
end
