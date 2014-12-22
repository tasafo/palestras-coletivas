class EventConcern < ApplicationController
  extend ActiveSupport::Concern

  attr_reader :dates, :authorized, :open_enrollment, :can_record_presence, :show_users_present,
    :users_present, :users_active, :crowded, :new_subscription, :the_user_is_speaker, :enrollment,
    :image_top, :can_vote

  def initialize(event)
    @event = event
    @dates = (@event.start_date..@event.end_date).to_a
    @authorized = authorized_access?(@event)
    @open_enrollment = @event.deadline_date_enrollment >= Date.today
    @can_record_presence = @authorized && Date.today >= @event.start_date
    @show_users_present = Date.today > @event.end_date && !@can_record_presence

    @users_present = []
    @event.enrollments.presents.each { |e| @users_present << e.user }
    @users_present.sort_by! { |u| u._slugs }

    @users_active = []
    @event.enrollments.actives.each { |e| @users_active << { :name => e.user._slugs, :enrollment => e } }
    @users_active.sort_by! { |h| h[:name] }

    @crowded = @users_active.count >= @event.stocking

    @new_subscription = true

    if logged_in?
      @enrollment = Enrollment.where(:event => @event, :user => current_user).first

      @new_subscription = false if @enrollment

      @the_user_is_speaker = false

      @event.schedules.each do |schedule|
        if schedule.talk?
          schedule.talk.users.each do |user|
            @the_user_is_speaker = true if user.id == current_user.id
          end
        end
      end

      @open_enrollment = false if @the_user_is_speaker || @authorized
    end

    unless @event.to_public
      @event = nil unless @authorized
    end

    @image_top = ('01'..'12').to_a.sample

    @can_vote = @event && @event.accepts_submissions && @event.end_date >= Date.today
  end
end