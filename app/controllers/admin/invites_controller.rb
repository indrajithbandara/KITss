class Admin::InvitesController < AdminAreaController
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  def index
    @title = "Invite new users"
    @str = ""
    
    if params[:addresses]
      @str = params[:addresses]
      if not @str.empty?
        list = @str.split(',')
        tosend = []
        list.each do |email|
          if email.strip =~ VALID_EMAIL_REGEX
            tosend << email.strip
          else
            flash.now[:error] = "Please verify the e-mail addresses for mistakes."
            return render
          end
        end

        # Send mails and add to database
        invites = Admin::Invite
        tosend.each do |email|
          # Add to database
          if not invites.exists?(:email => email)
            invites.new(:email => email, :inviter_id => current_user).save!
          end
          # TODO Send email
        end

        flash.now[:success] = "Mails have been sent"
        @str = ""
      else
        flash.now[:error] = "Please enter at least one e-mail address"
      end
    end
  end
end
