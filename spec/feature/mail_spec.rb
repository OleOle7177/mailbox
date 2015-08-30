require 'spec_helper'

describe "sending an email" do
  include Mail::Matchers

  before(:each) do
    Mail::TestMailer.deliveries.clear

    Mail.deliver do
      to ['mike1@me.com', 'mike2@me.com']
      from 'you@you.com'
      subject 'testing'
      body 'hello'
    end
  end

  it { should have_sent_email } # passes if any email at all was sent

  it { should have_sent_email.from('you@you.com') }
  it { should have_sent_email.to('mike1@me.com') }

  # can specify a list of recipients...
  it { should have_sent_email.to(['mike1@me.com', 'mike2@me.com']) }

  # ...or chain recipients together
  it { should have_sent_email.to('mike1@me.com').to('mike2@me.com') }

  it { should have_sent_email.with_subject('testing') }

  it { should have_sent_email.with_body('hello') }

  it { should have_sent_email.matching_subject(/test(ing)?/) }
  it { should have_sent_email.matching_body(/h(a|e)llo/) }

  # Can chain together modifiers
  # Note that apart from recipients, repeating a modifier overwrites old value.

  it { should have_sent_email.from('you@you.com').to('mike1@me.com').matching_body(/hell/) }
end