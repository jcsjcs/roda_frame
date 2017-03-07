module Framework
  module Search
    class Filter
      def self.call(id, params)
        rpt = DataminerControl.get_report_from_search(id)
        qps = rpt.query_parameter_definitions
        OpenStruct.new(rpt: rpt, qps: qps, rpt_id: id, load_params: (params[:back] && params[:back] == 'y') )
      end
    end
  end
end
