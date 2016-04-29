#!/usr/bin/ruby

class Wunderlist

    def initialize(client_id,access_token)
        @client_id=client_id
        @access_token=access_token
    end

    def get_lists
        get "a.wunderlist.com/api/v1/lists"
    end

    def get_list_by_id(id)
        get "a.wunderlist.com/api/v1/lists/#{id}"
    end

    def get_tasks_by_list_id(id)
        get "a.wunderlist.com/api/v1/tasks?list_id=#{id}"
    end

    private
    def get(url)
        c = Curl::Easy.new(url) do |curl|
            curl.headers["X-Client-ID"] = @client_id
            curl.headers["X-Access-Token"] = @access_token
        end
        c.perform
        c.body_str
    end





end
