class DataminerControl
  # TODO: Use some kind of config for this
  ROOT = File.join(File.dirname(__FILE__), '..')

  # Could we store dataminer behaviours in another yml file?
  # - rules for colours
  # - rules for links
  # - etc

  #TODO: remove repository.
  #      Should use db connection directly.
  #      ...able to use > 1 database?
  def self.grid_from_dataminer(repository, file_name, options={})
    report = get_report_with_options(file_name, options)
    col_defs = []
    #TODO: ::::::::: pivot....

    # Get from meta for grid....
    # hs = {headerName: 'Edit', field: 'id', colId: 'edit_link', cellRenderer: 'crossbeamsGridFormatters.hrefInlineFormatter'}
    # col_defs << hs

    #hs = {headerName: 'Edit', field: 'id', colId: 'edit_link', cellRenderer: 'crossbeamsGridFormatters.hrefInlineJsFormatter'} # value derive from hash of JSON (url + id field + display value) grid context help here?
    #hs = {headerName: 'Edit2', valueGetter: "<a href='/books/'+data.id+'/edit'>ed</a>", colId: 'edit_link2'}
    hs = {headerName: '',
          width: 60,
          suppressMenu: true, suppressSorting: true, suppressMovable: true, suppressFilter: true, enableRowGroup: false, enablePivot: false, enableValue: false, suppressCsvExport: true, suppressToolPanel: true,
          valueGetter: "'/books/' + data.id + '/edit|edit'", colId: 'edit_link2', cellRenderer: 'crossbeamsGridFormatters.hrefSimpleFormatter'}
    #hs = {headerName: 'Edit2', field: 'id', valueGetter: "'/books/' + data.id + '/edit|' + data.id", colId: 'edit_link2', cellRenderer: 'crossbeamsGridFormatters.hrefSimpleFormatter'}
    # 1: with text, 2: with data value...
    col_defs << hs

    # TODO: Delete - with prompt and DELETE method, not GET!
    hs = {headerName: '',
          width: 60,
          suppressMenu: true, suppressSorting: true, suppressMovable: true, suppressFilter: true, enableRowGroup: false, enablePivot: false, enableValue: false, suppressCsvExport: true,
          valueGetter: "'/books/' + data.id + '|delete|Are you sure?'", colId: 'delete_link', cellRenderer: 'crossbeamsGridFormatters.hrefPromptFormatter'}
    col_defs << hs
    col_defs += column_definitions(report)

    #TODO: ActionColumns and menu. Use context for link text? - keep out of valueGetters?

    {
      columnDefs: col_defs,
      #rowDefs:    repository.raw_query(report.runnable_sql)
      rowDefs:    dataminer_query(report.runnable_sql)#repository.raw_query(report.runnable_sql)
    }.to_json
  end

  def self.setup_report_with_parameters(report, params)
    #{"col"=>"users.department_id", "op"=>"=", "opText"=>"is", "val"=>"17", "text"=>"Finance", "caption"=>"Department"}
    input_parameters = ::JSON.parse(params[:json_var])
    parms = []
    # Check if this should become an IN parmeter (list of equal checks for a column.
    eq_sel = input_parameters.select { |p| p['op'] == '=' }.group_by { |p| p['col'] }
    in_sets = {}
    in_keys = []
    eq_sel.each do |col, qp|
      in_keys << col if qp.length > 1
    end

    input_parameters.each do |in_param|
      col = in_param['col']
      if in_keys.include?(col)
        in_sets[col] ||= []
        in_sets[col] << in_param['val']
        next
      end
      param_def = report.parameter_definition(col)
      if 'between' == in_param['op']
        parms << Crossbeams::Dataminer::QueryParameter.new(col, Crossbeams::Dataminer::OperatorValue.new(in_param['op'], [in_param['val'], in_param['val_to']], param_def.data_type))
      else
        parms << Crossbeams::Dataminer::QueryParameter.new(col, Crossbeams::Dataminer::OperatorValue.new(in_param['op'], in_param['val'], param_def.data_type))
      end
    end
    in_sets.each do |col, vals|
      param_def = report.parameter_definition(col)
      parms << Crossbeams::Dataminer::QueryParameter.new(col, Crossbeams::Dataminer::OperatorValue.new('in', vals, param_def.data_type))
    end

    report.limit  = params[:limit].to_i  if params[:limit] != ''
    report.offset = params[:offset].to_i if params[:offset] != ''
    begin
      report.apply_params(parms)
    rescue StandardError => e
      return "ERROR: #{e.message}"
    end
  end

  def self.grid_from_dataminer_search(id, params)
    search_def = load_search_definition(id)
    report     = get_report(search_def[:dataminer_definition])
    setup_report_with_parameters(report, params)

    actions  = search_def[:actions]
    col_defs = column_definitions(report, actions: actions)

    {
      columnDefs: col_defs,
      rowDefs:    dataminer_query(report.runnable_sql)#repository.raw_query(report.runnable_sql)
    }.to_json
  end

  def self.agg_func_for_column(col)
    case
    when col.group_sum
      :sum
    when col.group_avg
      :avg
    when col.group_min
      :min
    when col.group_max
      :max
    else
      nil
      ### count ?????
    end
  end

  def self.dataminer_query(sql)
    # this_db = Sequel.connect('postgres://postgres:postgres@localhost:5432/bookshelf_development')
    # # Need to convert all BigDecimal to float for JSON (otherwise the aggregations don't work because amounts are returned as 0.1126673E5)
    # # - Need to do some checking that the resulting float is an accurate representation of the decimal...
    # this_db[sql].to_a.map {|m| m.keys.each {|k| if m[k].is_a?(BigDecimal) then m[k] = m[k].to_f; end }; m; }
    DB.base[sql].to_a.map {|m| m.keys.each {|k| if m[k].is_a?(BigDecimal) then m[k] = m[k].to_f; end }; m; }
  end

  def self.dataminer_fetch(repository, file_name, options={})
    report = get_report_with_options(file_name, options)
    # this_db = Sequel.connect('postgres://postgres:postgres@localhost:5432/bookshelf_development')
    #  #this_db = Sequel.connect('postgres://postgres:postgres@localhost:5432/stargrow')
    # this_db[report.runnable_sql]
    DB.base[report.runnable_sql]
    #Sequel.connect('postgres://user:password@host:port/database_name'){|db| db[:posts].delete}
    #repository.raw_query(report.runnable_sql)
  end

  def self.get_report_from_search(file_name)
    search_def = load_search_definition(file_name)
    get_report(search_def[:dataminer_definition])
  end

  def self.load_search_definition(file_name)
    path    = File.join(ROOT, 'grid_definitions', 'searches', file_name.sub('.yml', '') << '.yml')
    YAML.load(File.read(path))
  end

  # Load a YML report.
  def self.get_report(file_name) #TODO:  'bookshelf' should be variable...
    path     = File.join(ROOT, 'grid_definitions', 'dataminer_queries', file_name.sub('.yml', '') << '.yml')
    rpt_hash = Crossbeams::Dataminer::YamlPersistor.new(path)
    Crossbeams::Dataminer::Report.load(rpt_hash)
  end

  private

  def self.column_definitions(report, options = {})
    col_defs = []

    # Actions
    # TODO:
    #       1. Combine into action collection column.
    #       2. Bring user permissions in to play.
    if options[:actions]
      options[:actions].each_with_index do |action, index|
        renderer = action[:is_delete] ? 'crossbeamsGridFormatters.hrefPromptFormatter' : 'crossbeamsGridFormatters.hrefSimpleFormatter'
        suffix   = "|#{action[:text] || 'link'}"
        if action[:is_delete]
          suffix << "|Are you sure?"
        end
        link = "'#{action[:url].gsub('{:id}', "'+data.id+'")}#{suffix}'"

        hs = {headerName: '',
              width: action[:width] || 60,
              suppressMenu: true,   suppressSorting: true,   suppressMovable: true,
              suppressFilter: true, enableRowGroup: false,   enablePivot: false,
              enableValue: false,   suppressCsvExport: true, suppressToolPanel: true,
              valueGetter: link,
              colId: "link_#{index}",
              cellRenderer: renderer }
        col_defs << hs
      end
    end

    report.ordered_columns.each do | col|
      hs                  = {headerName: col.caption, field: col.name, hide: col.hide, headerTooltip: col.caption}
      hs[:width]          = col.width unless col.width.nil?
      hs[:enableValue]    = true if [:integer, :number].include?(col.data_type)
      hs[:enableRowGroup] = true unless hs[:enableValue] && !col.groupable
      hs[:enablePivot]    = true unless hs[:enableValue] && !col.groupable
      if [:integer, :number].include?(col.data_type)
        hs[:cellClass] = 'grid-number-column'
        hs[:width]     = 100 if col.width.nil? && col.data_type == :integer
        hs[:width]     = 120 if col.width.nil? && col.data_type == :number
      end
      if col.format == :delimited_1000
        hs[:cellRenderer] = 'crossbeamsGridFormatters.numberWithCommas2'
      end
      if col.format == :delimited_1000_4
        hs[:cellRenderer] = 'crossbeamsGridFormatters.numberWithCommas4'
      end
      if col.data_type == :boolean
        hs[:cellRenderer] = 'crossbeamsGridFormatters.booleanFormatter'
        hs[:cellClass]    = 'grid-boolean-column'
        hs[:width]        = 100 if col.width.nil?
      end

      # hs[:cellClassRules] = {"grid-row-red": "x === 'Fred'"} if col.name == 'author'

      col_defs << hs
    end
    col_defs
  end

  # Set up a YML-loaded report with options.
  def self.get_report_with_options(file_name, options={})
    report          = get_report(file_name)
    report.limit    = options[:limit]  if options[:limit]
    report.offset   = options[:offset] if options[:offset]
    report.order_by = options[:order]  if options[:order]

    dm_params = (options[:dm_params] || {})
    if options[:quick_params] && {} == dm_params
      options[:quick_params].each { |fld, val| dm_params[fld] = {value: val} }
    end

    parms = []
    dm_params.each do |f, op_value|
      field      = f.to_s
      value      = op_value[:value]
      oper       = op_value[:operator] || '='
      data_type  = op_value[:data_type]
      col        = report.column(field)
      param_name = col.nil? ? field : col.namespaced_name
      param_def  = report.parameter_definition(param_name)

      if param_def.nil?
        parms << Crossbeams::Dataminer::QueryParameter.new(param_name, Crossbeams::Dataminer::OperatorValue.new(oper, value, data_type))
      else
        parms << Crossbeams::Dataminer::QueryParameter.from_definition(param_def, Crossbeams::Dataminer::OperatorValue.new(oper, value, data_type))
      end
    end
    report.apply_params(parms) unless parms.empty?
    report
  end

end
