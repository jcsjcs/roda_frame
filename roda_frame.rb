# TODO: Get robocop in from the start....
require 'roda'
require 'rodauth'
require 'awesome_print'
require 'rom'
require 'rom-sql'
require 'rom-repository'
require 'crossbeams/layout'
require 'crossbeams/dataminer'
require 'crossbeams/dataminer_interface'
require 'crossbeams/label_designer'
require 'crossbeams/rack_middleware'
require 'yaml'
require 'base64'
#require 'pry'

Dir['./helpers/**/*.rb'].each { |f| require f }
# Dir['./persistence/**/*.rb'].each { |f| require f }
# Dir['./persistence/**/*.rb'].each { |f| puts f }
require './repositories/user_repo'
require './repositories/commodity_repo'
# require './repositories/supplier_invoice_repo'
# require './repositories/payment_term_repo'
require './repositories/warehouse/book_repo' # pretend warehouse repo.
require './lib/db_connections'
require './lib/dataminer_control'
# require './models'


DB = DBConnections.new
# DB.base.use_logger(Logger.new($stdout)) # This will log SQL to console.

# Make dry-container
# add ROM container
# Make auto-inject
# include auto-inject in app
# call ROM via the inject...

class RodaFrame < Roda
  include CommonHelpers

  use Rack::Session::Cookie, secret: "some_nice_long_random_string_DSKJH4378EYR7EGKUFH", key: "_myapp_session"
  use Crossbeams::RackMiddleware::Banner, template: 'views/_page_banner.erb'#, session: request.session
  # use Crossbeams::DataminerInterface::App, url_prefix: 'dataminer/', dm_reports_location: '/home/james/ra/roda_frame/reports',
  use Crossbeams::DataminerInterface::App, url_prefix: 'dataminer/',
    dm_reports_location: File.join(File.dirname(__FILE__), 'reports'),
    dm_js_location: 'js', dm_css_location: 'css', db_connection: DB.base

  plugin :render
  plugin :partials
  plugin :assets, css: 'style.scss'#, js: 'behave.js'
  plugin :public # serve assets from public folder.
  plugin :view_subdirs
  plugin :multi_route
  plugin :content_for, :append=>true
  plugin :indifferent_params
  plugin :flash
  plugin :csrf # , :skip => ['POST:/report_error']
    plugin :rodauth do
      db DB.base.connection
      enable :login, :logout#, :change_password
      logout_route 'a_dummy_route' # Override 'logout' route so that we have control over it.
      # logout_notice_flash 'Logged out'
      session_key :user_id
      login_param 'user_name'
      login_label 'Login name'
      login_column :user_name
      accounts_table :users
      account_password_hash_column :hashed_password
      require_bcrypt? false
      password_match? do |password| # Use legacy password hashing. Maybe change this to modern bcrypt using extra new pwd field?
        account[:hashed_password] == Base64.encode64(password)
      end
      # title_instance_variable :@title
      # if DEMO_MODE
      #   before_change_password{r.halt(404)}
      # end
    end
  # plugin :error_handler do |e|
  #   # TODO: how to handle AJAX/JSON etc...
  #   view(inline: "An error occurred - #{e.message}") # TODO: refine this to handle certain classes of errors in certain ways.
  #   # (could do something like - inline: render errorview(e) ...)
  # end
  Dir['./routes/*.rb'].each { |f| require f }

  # TODO: route for dataminer.
  # MyApp.run(DB.db) # for sharing connection...

  route do |r|
    r.assets unless ENV['RACK_ENV'] == 'production'
    r.public
    r.rodauth
    r.redirect('/login') unless session[:user_id]
    r.root do
      # 'At the Root' # If not logged-in, redirect to login?
      # Relations::Users.new.first.inspect
      # ROM.env.relations[:users].inspect
      # ROM.methods.inspect
      # r.redirect 'login/'
      # s = DB.base['select * from users limit 2'].to_a.inspect
      # s << DB.base['select * from users order by id desc limit 2'].to_a.inspect
      # s << '<p>---</p>'
      # s << DB.base(:warehouse)['select * from books'].to_a.inspect
      # user_repo = UserRepo.new(DB.db)
      # s = user_repo.query('id > 164').to_a.map { |a| a.class.name }.inspect
      # book_repo = BookRepo.new(DB.db)
      # # supplier_invoice_repo = SupplierInvoiceRepo.new(DB.db)
      # # s << '<p>---</p>'
      # # s << supplier_invoice_repo.query('id < 3').first.pallet_filter.inspect
      # # s << '<br>'
      # # s << "<p>TST: #{ar = supplier_invoice_repo.query('id < 3').first.pallet_filter; ar.class}... need to get to Array!!!!!</p>"
      # # s << "<p>FILTER: #{supplier_invoice_repo.query('id < 3').first.pallet_filter.class.name}</p>"
      # # s << supplier_invoice_repo.query('id < 3').first.status.class.name
      # s << '<p>---</p>'
      # s << book_repo.query('id < 3').to_a.map { |b| b.title }.inspect
      # s << '<p>---</p>'
      # s << user_repo.count_them[:count].to_s #.to_a.inspect
      # #s << user_repo.relations.entries.inspect#methods.sort.inspect
      # # pt_repo = PaymentTermRepo.new(DB.db)
      # # s << "<p>DESC: #{pt_repo.payment_terms.first.short_description}...</p>"
      # # #s << pt_repo.payment_terms.new({}).days #methods.sort.inspect
      # # s << pt_repo.payment_terms.methods.sort.inspect
      s = <<-EOS
      <h2>Kromco packhouse</h2>
      <p>There are currently 99 bins and 99 pallets on site.</p>
      <p>Since 1 December 2016: <ul>
      <li>99 deliveries have been received</li>
      <li>99 cartons have been packed</li>
      </p>
      EOS
      view(inline: s)
    end
    r.multi_route
    r.is 'test' do
      view('test_view')
    end

    r.is 'logout' do
      rodauth.logout
      flash[:notice] = 'Logged out'
      r.redirect('/login')
    end

    # TEST Grid:
    r.is 'grid' do
      #view('grid')
      #locals[:crossbeams_layout].build do |page|
      #
      book = Struct.new(:title, :author, :id).new('Book name', 'John J', 12)
      @layout = Crossbeams::Layout::Page.new form_object: book, name: 'book'

      @layout.build do |page|
        page.add_grid('grd1', '/grid_data', caption: 'Test grid')
      end

      view('crossbeams_layout_page')
    end
    r.is 'grid_data' do
      response['Content-Type'] = 'application/json'
      #'TODO: return json rows for grid'
      col_defs = []
      row_defs = []
      hs                  = {headerName: 'Name', field: 'name'}
      col_defs << hs
      # hs[:width]          = col.width unless col.width.nil?
      # hs[:enableValue]    = true if [:integer, :number].include?(col.data_type)
      # hs[:enableRowGroup] = true unless hs[:enableValue] && !col.groupable
      # hs[:enablePivot]    = true unless hs[:enableValue] && !col.groupable
      # if [:integer, :number].include?(col.data_type)
      #   hs[:cellClass] = 'grid-number-column'
      #   hs[:width]     = 100 if col.width.nil? && col.data_type == :integer
      #   hs[:width]     = 120 if col.width.nil? && col.data_type == :number
      # end
      # if col.format == :delimited_1000
      #   hs[:cellRenderer] = 'crossbeamsGridFormatters.numberWithCommas2'
      # end
      # if col.format == :delimited_1000_4
      #   hs[:cellRenderer] = 'crossbeamsGridFormatters.numberWithCommas4'
      # end
      # if col.data_type == :boolean
      #   hs[:cellRenderer] = 'crossbeamsGridFormatters.booleanFormatter'
      #   hs[:cellClass]    = 'grid-boolean-column'
      #   hs[:width]        = 100 if col.width.nil?
      # end

      row_defs << {name: 'Fred'}

      {
        columnDefs: col_defs,
        #rowDefs:    repository.raw_query(report.runnable_sql)
        #rowDefs:    dataminer_query(report.runnable_sql)#repository.raw_query(report.runnable_sql)
        rowDefs: row_defs
      }.to_json
      #{"columnDefs":[{"headerName":"","width":60,"suppressMenu":true,"suppressSorting":true,"suppressMovable":true,"suppressFilter":true,"enableRowGroup":false,"enablePivot":false,"enableValue":false,"suppressCsvExport":true,"suppressToolPanel":true,"valueGetter":"'/books/' + data.id + '/edit|edit'","colId":"edit_link2","cellRenderer":"crossbeamsGridFormatters.hrefSimpleFormatter"},{"headerName":"","width":60,"suppressMenu":true,"suppressSorting":true,"suppressMovable":true,"suppressFilter":true,"enableRowGroup":false,"enablePivot":false,"enableValue":false,"suppressCsvExport":true,"valueGetter":"'/books/' + data.id + '|delete|Are you sure?'","colId":"delete_link","cellRenderer":"crossbeamsGridFormatters.hrefPromptFormatter"},{"headerName":"Id","field":"id","hide":true,"headerTooltip":"Id","enableValue":true,"cellClass":"grid-number-column","width":100},{"headerName":"Title","field":"title","hide":false,"headerTooltip":"Title","width":200,"enableRowGroup":true,"enablePivot":true},{"headerName":"Author","field":"author","hide":false,"headerTooltip":"Author","width":150,"enableRowGroup":true,"enablePivot":true}],"rowDefs":[{"id":2,"title":"Fred is Green, and Blue","author":"Fred"},{"id":3,"title":"A new book > Old book","author":"John"},{"id":1,"title":"TDD","author":"Kent Beck"},{"id":5,"title":"600980218299308328","author":"Pallet number"},{"id":4,"title":"Something","author":"Someones"}]}.to_json
    end

    # TEST Crossbeams::Layout
    r.is 'lay' do
      # USe layout...
      book = Struct.new(:title, :author, :id).new('Book name', 'John J', 12)
      @layout = Crossbeams::Layout::Page.new form_object: book, name: 'book'

      @layout.with_form do |form, page_config|

          form.action '/save_book' #routes.book_path(id: page_config.form_object.id)
          # form.action routes.book_path(id: book.id)
          form.method :update

          form.add_field :title
          form.add_field :author
          # form.row do |row|
          # end
      end

      view('crossbeams_layout_page')
    end
  end

end
