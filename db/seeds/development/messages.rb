customer = Customer.all
staff_member = StaffMember.where(suspended: false).all

s = 2.years.ago
23.times do |n|
  m = CustomerMessage.create!(
    customer: customer.sample,
    subject: "これはお問い合わせです。" * 4,
    body: "これはお問い合わせです。\n" * 8,
    created_at: s.advance(months: n)
  )
  r = StaffMessage.create!(
    customer: m.customer,
    staff_member: staff_member.sample,
    root: m,
    parent: m,
    subject: "これは返信です。" * 4,
    body: "これは返信です。\n" * 8,
    created_at: s.advance(months: n, hours: 1)
  )

  if n % 6 == 0
    m2 = CustomerMessage.create!(
      customer: r.customer,
      root: m,
      parent: r,
      subject: "これは返信への回答です。" * 4,
      body: "これは返信への回答です。\n" * 8,
      created_at: s.advance(months: n, hours: 2)
    )

    StaffMessage.create!(
    customer: m2.customer,
    staff_member: staff_member.sample,
    root: m,
    parent: m2,
    subject: "これは回答への返信です。" * 4,
    body: "これは回答への返信です。\n" * 8,
    created_at: s.advance(months: n, hours: 1)
    )
  end
end

s = 24.hours.ago
8.times do |n|
  CustomerMessage.create!(
    customer: customer.sample,
    subject: "これはお問い合わせです" * 4,
    body: "これはお問い合わせです。\n" * 8,
    created_at: s.advance(hours: n * 3)
  )
end