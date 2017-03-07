module Framework
  module Search
    class Filter
      def self.call(id, params)
        dmc = DataminerControl.new(search_file: id)
        OpenStruct.new(rpt: dmc.report, qps: dmc.report.query_parameter_definitions, rpt_id: id, load_params: (params[:back] && params[:back] == 'y') )
      end
    end
  end
end
