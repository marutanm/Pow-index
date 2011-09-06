POW_PATH = "#{ENV['HOME']}/.pow"
enable :inline_templates

get '/' do
  @pows = Dir[POW_PATH + "/*"].map { |link| File.basename(link) }
  haml :index
end

__END__

@@ index
%html
  %head
    %title pow index
    %link{:rel => 'stylesheet', :href => 'http://twitter.github.com/bootstrap/assets/css/bootstrap-1.2.0.min.css'}
  %body
    .container
      %h1 index
      %table.zebra-striped
        %tbody
          - @pows.each do |pow|
            %tr
              %td
                %a{:href => 'http://' + pow + '.dev'} 
                  = pow
