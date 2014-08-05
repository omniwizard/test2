require 'date'
require 'time'


class EventsController < ApplicationController
  def new
  end

  def create
    @events = Events.new(events_params)

    @events.save
    redirect_to '/'
  end

  def edit
    @events = Events.find(params[:id])
  end

  def show
    @events = Events.find(params[:id])
  end

  def index
    @events = Events.all

  end

  def update
    @event = Events.find(params[:id])

    if @event.update(events_params)
      redirect_to '/'
    else
      render 'edit'
    end
  end

  def destroy
    @event = Events.find(params[:id])

    @event.delete
    redirect_to '/'
  end

  def list
    cal_start  = DateTime.parse(params['start'])
    cal_end  = DateTime.parse(params['end'])

    if params['all_events'] == 'true'
      @events = Events.all
    else
      @events = Events.where(:user => current_user.to_param)
    end
    events = []
    @events.each { |event|
      i = cal_end - (event.event_data.iso8601).to_date
      current = (event.event_data.iso8601).to_datetime
      if event.period ==1
        if i>0
          z=1
          while  z <= i.to_i do
            events << {:id => event.id, :title => event.event_name, :start => "#{current + z}", :end => "#{current + z}", :allDay => false}
            z+=1
          end
        end
      elsif  event.period == 2
        if i.to_i> 7
          we = i.to_i/7
          x = 1
          while x <= we

            events << {:id => event.id, :title => event.event_name, :start => "#{current + x.week}", :end => "#{current + x.week}", :allDay => false}
            x+=1
          end
        end
      elsif  event.period == 3
        if i.to_i> 30
          mon = i.to_i/30
          x = 1
          while x <= mon
            events << {:id => event.id, :title => event.event_name, :start => "#{current + x.month}", :end => "#{current + x.month}", :allDay => false}
            x+=1
          end
        end
      elsif  event.period == 4
          if i.to_i> 365
            ya = i.to_i/365
            x = 1
            while x <= ya
              current = (event.event_data.iso8601).to_date
              events << {:id => event.id, :title => event.event_name, :start => "#{current + x.year}", :end => "#{current + x.year}", :allDay => false}
              x+=1
            end
        end
      end
      events << {:id => event.id, :title => event.event_name, :start => "#{event.event_data.iso8601}", :end => "#{event.event_data.iso8601}", :allDay => false}
    }


    render :text => events.to_json
  end

  private
  def events_params
    params.require(:events).permit(:event_name, :event_data, :user, :period)
  end

end