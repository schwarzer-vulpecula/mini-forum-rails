module ApplicationHelper

  # Sanitizes parameters according to various rules
  def sanitize(params)
    params.each_key do |k|
      if k == 'content'
        # Squish each individual lines instead
        content_array = params[k].split("\n")
        for i in 0...content_array.length
          content_array[i] = content_array[i].squish
        end
        # Rejoin the lines into one
        params[k] = content_array.reject(&:blank?).join("\n")
      elsif k == 'password' || k == 'password_confirmation'
        # Do not sanitize password fields
        next
      else
        # Squish it
        params[k] = params[k].squish
      end
    end
    return params
  end

  # Redirect to given location with a flash telling the user that they are not authorized
  def unauthorized_redirect_to(location)
    flash[:alert] = "You are not authorized to do that."
    redirect_to location
  end

end
