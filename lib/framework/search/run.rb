module Framework
  module Search
    class Run
      def self.call(id, params)
        dmc = DataminerControl.new(search_file: id)
        dmc.apply_params(params)

        layout = Crossbeams::Layout::Page.new form_object: dmc.report
        layout.build do |page, page_config|
          page.row do |row|
            row.column do | col|
              col.add_text "<a href='/search/#{id}?back=y'>Back</a>"
            end
          end
          page.add_grid('grd1', "/search/#{id}/grid?json_var=#{CGI.escape(params[:json_var])}" <<
                                "&limit=#{params[:limit]}&offset=#{params[:offset]}",
                        caption: page_config.form_object.caption)
        end
        layout
      end
    end
  end
end

