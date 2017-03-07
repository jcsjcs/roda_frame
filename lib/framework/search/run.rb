module Framework
  module Search
    class Run
      def self.call(id, params)
        report = DataminerControl.get_report_from_search(id)
        DataminerControl.setup_report_with_parameters(report, params)

        layout = Crossbeams::Layout::Page.new form_object: report
        layout.build do |page, page_config|
          page.add_grid('grd1', "/search/#{id}/grid?json_var=#{CGI.escape(params[:json_var])}" <<
                                "&limit=#{params[:limit]}&offset=#{params[:offset]}",
                        caption: page_config.form_object.caption)
        end
        layout
      end
    end
  end
end

