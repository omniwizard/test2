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
  def list

    # @events = Events.all
    # events = []
    # @events.each do |event|
    #   events << {:id => event.id, :title => event.event_name, :start => "#{event.event_data.iso8601}", :end => "#{event.event_data.iso8601}", :allDay => false}
    # end
    if params['all_events'] == 'true'
      @events = Events.all
    else
      @events = Events.where(:user => current_user)
    end
    events = []
    @events.each do |event|
      events << {:id => event.id, :title => event.event_name, :start => "#{event.event_data.iso8601}", :end => "#{event.event_data.iso8601}", :allDay => false}
    end
    render :text => events.to_json
  end
  private
  def events_params
    params.require(:events).permit(:event_name, :event_data , :user, :period )
  end

end