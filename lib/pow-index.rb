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
    %link{:rel => 'stylesheet', :href => '/assets/bootstrap.min.css'}
    %link{:rel => 'stylesheet', :href => '/assets/bootstrap-responsive.min.css'}
    %script{:type => 'text/javascript', :src => 'assets/jquery.min.js'}
    = haml :js
  %body
    .container
      %h1 pow index
      %table.table-striped#linktable
      .row
        %button.btn.small#toggle{:onClick => 'toggle()'} Cleanup
        .alert-message.block-message.warning#confirm{'style' => 'display: none'}
          %button.btn.small{:onClick => 'cleanup()'} Cleanup
          %button.btn.small{:onClick => 'toggle()'} Cancel
          %p= "Pushing 'Cleanup' removes invalid symbolic link in ~/.pow"

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
  function toggle(){
    $.each(['toggle', 'confirm'], function() {
      if(document.getElementById(this).style.display == 'none'){
        document.getElementById(this).style.display = 'block';
      }else{
        document.getElementById(this).style.display = 'none';
      }
    })
  }
  function cleanup() {
    $.ajax({
      type: "GET",
      url: "/cleanup",
      dataType: "html",
      success: function(){
        loadtable();
        toggle();
      }
    })
  }
  $(function(){ loadtable(); })
