class CasAuthentication
  def initialize(session)
    @session = session
  end

  def user
    if username.present?
      @user ||= User.find_or_initialize_by(username: username)
    end
  end

  def perform
    if authenticated?
      true
    elsif present?
      if new_user?
        if create_user!
          authenticate!
        end
      elsif unauthenticated?
        authenticate!
        update_extra_attributes!
      end
    end
  end

  def attributes
    {
      id_number:    extra_attr(:employeeId),
      first_name:   extra_attr(:eduPersonNickname),
      last_name:    extra_attr(:sn),
      email:        extra_attr(:mail),
      photo_url:    extra_attr(:url),
      entitlements: extra_attrs(:eduPersonEntitlement),
      affiliations: extra_attrs(:eduPersonAffiliation)
    }
  end

  private

  attr_reader :session

  def present?
    session['cas'].present?
  end

  def new_user?
    !!user.try(:new_record?)
  end

  def authenticated?
    session[:username].present?
  end

  def unauthenticated?
    !authenticated?
  end

  def authenticate!
    session[:username] = username
  end

  def update_extra_attributes!
    user.update attributes
  end
  alias :create_user! :update_extra_attributes!

  def username
    session[:username] || attrs['user']
  end

  def attrs
    @attrs ||= (session['cas'] || {}).with_indifferent_access
  end

  def extra_attributes
    @extra_attributes ||= (attrs['extra_attributes'] || {}).with_indifferent_access
  end

  def extra_attr(key)
    # Many values come back as arrays but don't really need to be
    extra_attrs(key).first
  end

  def extra_attrs(key)
    Array(extra_attributes[key]).map(&:to_s)
  end
end
