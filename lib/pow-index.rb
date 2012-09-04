require "pow-index/version"
require 'sinatra/base'

module PowIndex

  class App < Sinatra::Base

    POW_PATH = "#{ENV['HOME']}/.pow"
    enable :inline_templates

    get '/' do
      @pows = (Dir[POW_PATH + "/*"] - [ "#{ENV['HOME']}/.pow/#{request.host.gsub(/.dev$/, '')}" ]).map { |link| File.basename(link)}
      haml :index
    end

    get '/cleanup' do
      require 'fileutils'
      Dir[POW_PATH + "/*"].map { |symlink| FileUtils.rm(symlink) unless File.exists? File.readlink(symlink) }
      @pows = Dir[POW_PATH + "/*"].map { |link| File.basename(link)}
      ## Snapshots generation
      path = "#{File.expand_path(File.dirname(__FILE__)).chomp}/../public/snaps/"
      @snaps = Dir[POW_PATH + "/*"].map { |symlink|
        link = symlink.rpartition("/").last
        system "webkit2png -D #{path} -o #{link} -C http://#{link}.dev" unless link.eql?("default")
      }
      haml :linktable
    end

    get '/linktable' do
      @pows = (Dir[POW_PATH + "/*"] - [ "#{ENV['HOME']}/.pow/#{request.host.gsub(/.dev$/, '')}" ]).map { |link| File.basename(link)}
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
  %body
    .container
      #linktable

      .modal.hide#toggle
        .modal-header
          %h3 Cleanup
        .modal-body
          %p= "Remove invalid symbolic links in ~/.pow and regenerate snapshots"
        .modal-footer
          %a.btn.btn-primary{:onClick => 'cleanup()'} OK
          %a.btn{:'data-dismiss' => 'modal'} cancel

    #footer
      .container
        %img{:src => "img/logo-pow.png"}
        .nav.pull-right
          %a.btn{:'data-toggle' => "modal", :href => '#toggle', :alt => "Refresh links"}
            %i.icon-refresh

@@ linktable
%ul#pows
  - @pows.each do |pow|
    - unless pow.eql?("default")
      %li.pow
        %a{:href => "http://#{pow}.dev"} 
          %img{:src => "snaps/#{pow}-clipped.png"}
        %a.title{:href => "http://#{pow}.dev"}
          = pow

@@ js
:javascript
  function loadtable(){
    $('#linktable').load('/linktable');
  }

  function cleanup() {
    $.ajax({
      type: "GET",
      url: "/cleanup",
      dataType: "html",
      success: function(){
        loadtable();
        $('#toggle').modal('hide');
      }
    });
  }
  
  $(document).ready(function(){ 
    loadtable();  
  });
