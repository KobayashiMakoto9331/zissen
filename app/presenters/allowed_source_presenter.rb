class AllowedSourcePresenter < ModelPresenter
  delegate :octet1, :octet2, :octet3, :octet4, :wildcard?, :created_at, to: :object

  def ip_address
    [ octet1, octet2, octet3, wildcard? ? "*" : octet4 ].join(".")
  end

  def created
    created_at.strftime("%Y/%m/%d %H:%M:%S")
  end
end