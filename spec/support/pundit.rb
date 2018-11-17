# frozen_string_literal: true

shared_context "when not authorized" do |policy_class, policy_method|
  before do
    policy =
      instance_double("policy", policy_method => false, error_code: nil, "error_code=" => nil)
    allow(policy_class).to receive(:new).and_return(policy)
  end
end

shared_context "when authorized" do |policy_class, policy_method|
  before do
    policy = instance_double("policy", policy_method => true, error_code: nil, "error_code=" => nil)
    allow(policy_class).to receive(:new).and_return(policy)
  end
end
