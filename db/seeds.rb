# frozen_string_literal: true

kuba = User.create!(email: "kuba@example.com", password: "password", utc: -5)
kecper = User.create!(email: "kacper@example.com", password: "password", utc: +1)
dawid = User.create!(email: "dawid@example.com", password: "password", utc: +1)
kamil = User.create!(email: "kamil@example.com", password: "password", utc: +1)

group = Group.create!(
  meeting_length_in_minutes: 4 * 60,
  creator_required: true,
  min_users_in_meeting: 3,
  creator: kuba
)

Membership.create!(user: kuba, group: group)
Membership.create!(user: kecper, group: group)
Membership.create!(user: dawid, group: group)
Membership.create!(user: kamil, group: group)
