class RodaFrame < Roda
  route('search') do |r|
    r.on :id do |id|
      r.is do
        #"Show Filter for #{id}"
        @rpt = DataminerControl.get_report_from_search(id)
        @qps = @rpt.query_parameter_definitions
        @rpt_id = id
        #@load_params = params[:back] && params[:back] == 'y'
        view('search_filter')
      end
      r.on 'run' do
        puts ">>> RUN: #{params.inspect}"
        #"Show grid for #{id} - PARAMS: #{params.inspect}"
        report = DataminerControl.get_report_from_search(id)
        DataminerControl.setup_report_with_parameters(report, params)
        @layout = Crossbeams::Layout::Page.new form_object: report
        @layout.build do |page, page_config|
        # Add section with back link and toggle SQL...

          # page.add_grid('grd1', routes.searchgrid_path(id:       params[:id],
          #                                              json_var: params[:json_var],
          #                                              limit:    params[:limit],
          #                                              offset:   params[:offset]),
          #               caption: page_config.form_object.caption)
          # "json_var"=>"[{\"col\":\"users.department_id\",\"op\":\"=\",\"opText\":\"is\",\"val\":\"17\",\"val_to\":\"\",\"text\":\"Finance\",\"text_to\":\"\",\"caption\":\"Department\"}]"}
          #page.add_grid('grd1', "/search/#{id}/grid", caption: page_config.form_object.caption)
          page.add_grid('grd1', "/search/#{id}/grid?json_var=#{CGI.escape(params[:json_var])}&limit=#{params[:limit]}&offset=#{params[:offset]}", caption: page_config.form_object.caption)
        end
        view('crossbeams_layout_page')
      end

      r.on 'grid' do
        puts ">>> #{params.inspect}"
        response['Content-Type'] = 'application/json'
        DataminerControl.grid_from_dataminer_search(id, params)
      # data        = DataminerControl.grid_from_dataminer_search(params)
      # self.status = 200
      # self.body   = data

        #"Return grid rows as JSON for #{id}".to_json
      end
    end
  end
end
