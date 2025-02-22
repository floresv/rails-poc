# frozen_string_literal: true

require 'spec_helper'

describe Admin::UserPolicy do
  subject { described_class }

  permissions :update?, :index?, :show?, :create?, :new?, :edit?, :destroy? do
    let(:admin) { create(:admin_user) }
    let(:user)  { create(:user) }

    it 'allow access' do
      expect(subject).to permit(admin, user)
    end
  end
end
