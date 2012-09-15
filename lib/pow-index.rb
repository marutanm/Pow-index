require "pow-index/version"
require 'sinatra/base'

module PowIndex

  class App < Sinatra::Base

    POW_PATH = "#{ENV['HOME']}/.pow"
    IMAGE_PATH = "#{File.expand_path(File.dirname(__FILE__)).chomp}/../public/snaps/"
    enable :inline_templates

    def image_generation(link)
      system "webkit2png -D #{IMAGE_PATH} -o #{link} -C http://#{link}.dev" unless link.eql?("default")
    end

    get '/' do
      @pows = (Dir["#{POW_PATH}/*"] - [ "#{POW_PATH}/#{request.host.gsub(/.dev$/, '')}" ]).map { |link| File.basename(link)}
      haml :index
    end

    get '/cleanup' do
      require 'fileutils'
      Dir[POW_PATH + "/*"].map { |symlink| FileUtils.rm(symlink) unless File.exists? File.readlink(symlink) }
      @pows = Dir[POW_PATH + "/*"].map { |link| File.basename(link)}
      ## Snapshots generation
      @snaps = Dir[POW_PATH + "/*"].map { |symlink|
        link = symlink.rpartition("/").last
        image_generation(link)
      }
      haml :linktable
    end

    get '/linktable' do
      @pows = (Dir["#{POW_PATH}/*"] - [ "#{POW_PATH}/#{request.host.gsub(/.dev$/, '')}" ]).map { |link| File.basename(link)}
      haml :linktable
    end

    get '/regenerate/:link' do
      image_generation(params[:link])
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
        .action
          %a.reload.btn{:href => '#', :onClick => "regenerateImage('#{pow}')", :alt => 'Regenerate Image'}
            %i.icon-refresh

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
      },
      statusCode: {
        500: function() {
          $('#toggle').modal('hide');
          alert("Sorry, there is some problem");
        }
      }
    });
  }
  
  function regenerateImage(pow) {
    $.ajax({
      type: "GET",
      url: "/regenerate/" + pow,
      dataType: "html",
      success: function(){
        location.reload(true);
      }
    });
  }
  
  $(document).ready(function(){ 
    loadtable();  
  });
