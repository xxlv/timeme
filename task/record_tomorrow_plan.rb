#!/usr/bin/ruby

require './lib/wunderlist'
require 'time'

def record_tomorrow_plan

    wl=Wunderlist.new(ENV['WUNDERLIST_CLIENT_ID'],ENV['WUNDERLIST_ACCESS_TOKEN'])
    lists=JSON.parse(wl.get_lists)
    inbox_tasks,read_tasks,work_tasks=[]
    lists.each do |list|
        inbox_tasks= wl.get_tasks_by_list_id(list['id']) if list['title'].include? "inbox"
        read_tasks=wl.get_tasks_by_list_id(list['id']) if list['title'].include? "ReadList"
        work_tasks=wl.get_tasks_by_list_id(list['id']) if list['title'].include? "Work"
    end

    body =get_body_by(inbox_tasks)

    EVENTS << {:event=>"WUNDERLIST_INBOX",:time=>Time.now,:status=>0,:body=>body}

end

def get_body_by(tasks)

    tasks=JSON.parse(tasks)

    no_completed_tasks=[]

    tasks.each do |task|

        if task['due_date']
            if task['completed']==false && Time.parse(task['due_date']).to_i<=Time.parse(Date.today.to_s).to_i
                no_completed_tasks << "<div style='text-decoration: underline;'>#{task['title']} , [due date is #{task['due_date']}]</div>"
            end
        end
    end

    body='<div>'

    if(no_completed_tasks.count>0)
        body="<hr/> <div style='color:blue;'>[The following section is your wunder list <span style='background-color:red;color:white'>not completed</span> ]</div>#{no_completed_tasks.join('')}"
    end
    body+='Total plan !'+ tasks.count.to_s+'<br/>'
    body+='just do it now 😢!'
    body+='</div></div>'
    body

end
