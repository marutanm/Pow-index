require "pow-index/version"
require 'sinatra/base'

module PowIndex

  class App < Sinatra::Base

    POW_PATH = "#{ENV['HOME']}/.pow"
    enable :inline_templates

    get '/' do
      @pows = (Dir[POW_PATH + "/*"] - [ "#{ENV['HOME']}/.pow/#{request.host.gsub(/.dev$/, '')}" ]).map { |link| File.basename(link) }
      haml :index
    end

    get '/cleanup' do
      require 'fileutils'
      Dir[POW_PATH + "/*"].map { |symlink| FileUtils.rm(symlink) unless File.exists? File.readlink(symlink) }
      @pows = Dir[POW_PATH + "/*"].map { |link| File.basename(link) }
      haml :linktable
    end

    get '/linktable' do
      @pows = (Dir[POW_PATH + "/*"] - [ "#{ENV['HOME']}/.pow/#{request.host.gsub(/.dev$/, '')}" ]).map { |link| File.basename(link) }
      haml :linktable
    end
  end

end

__END__

@@ index
%html
  %head
    %title pow index
    %link{:rel => 'stylesheet', :href => 'styles.css'}

    %script{:type => 'text/javascript', :src => 'jquery.min.js'}
    %script{:type => 'text/javascript', :src => 'bootstrap-modal.js'}
    = haml :js
  %body{:style => 'padding-top:40px'}
    .navbar.navbar-fixed-top
      .navbar-inner
        .container
          .brand pow index
          .nav.pull-right
            %a.btn{:'data-toggle' => "modal", :href => '#toggle'}
              %i.icon-refresh
    .container
      %table.table.table-striped#linktable

      .modal.hide#toggle
        .modal-header
          %h3 Cleanup
        .modal-body
          %p= "Remove invalid symbolic links in ~/.pow"
        .modal-footer
          %a.btn.btn-primary{:onClick => 'cleanup()'} OK
          %a.btn{:'data-dismiss' => 'modal'} cancel

@@ linktable
%tbody
  - @pows.each do |pow|
    %tr
      %td
        %a{:href => "http://#{pow}.dev", :target => "_blank"}
          = pow

@@ js
:javascript
  function loadtable(){
    $('#linktable').load('/linktable')
  }
  function cleanup() {
    $.ajax({
      type: "GET",
      url: "/cleanup",
      dataType: "html",
      success: function(){
        loadtable();
        $('#toggle').modal('hide')
      }
    })
  }
  $(function(){ loadtable(); })
