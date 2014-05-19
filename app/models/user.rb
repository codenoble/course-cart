class User
  include Mongoid::Document

  has_many :orders
  field :username, type: String
  field :id_number, type: Integer
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :photo_url, type: String
  field :entitlements, type: Array
  field :affiliations, type: Array

  alias_attribute :netid, :username

  validates :username, presence: true, uniqueness: true

  scope :with_role, -> role { all.or(affiliations: role).or(:entitlements.in => User.role_to_entitlement(role)) }

  def name
    "#{self.first_name} #{self.last_name}".strip
  end
  alias :to_s :name

  def has_role?(*roles)
    (self.roles & roles).any?
  end

  def roles
    (Array(affiliations) + relevant_entitlements).map(&:to_sym)
  end

  private

  # Find URNs that match the namespaces and remove the namespace
  # See http://en.wikipedia.org/wiki/Uniform_Resource_Name
  def relevant_entitlements
    urns = Array(entitlements)
    nids = Settings.urn_namespaces

    return [] if urns.blank?

    clean_urns = urns.map { |e| e.gsub(/^urn:/i, '') }
    clean_nids = nids.map { |n| n.gsub(/^urn:/i, '') }

    clean_urns.map { |urn|
      clean_nids.map { |nid|
        urn[0...nid.length] == nid ? urn[nid.length..urn.length] : nil
      }
    }.flatten.compact
  end

  def self.role_to_entitlement(role)
    Settings.urn_namespaces.map do |namespace|
      "#{namespace}#{role}"
    end
  end
end