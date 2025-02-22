# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CategoryPolicy, type: :policy do
  subject { described_class }

  let(:user) { User.new }

  permissions '.scope' do
    let(:scope) { Category.all }

    it 'shows all categories to anyone' do
      expect(Pundit.policy_scope(nil, Category)).to eq(scope)
    end
  end

  permissions :show? do
    it 'allows access to anyone' do
      expect(subject).to permit(nil, Category.new)
    end
  end

  permissions :create? do
    context 'when user is an admin' do
      let(:user) { create(:admin_user) }

      it 'allows creating categories' do
        expect(subject).to permit(user, Category.new)
      end
    end

    context 'when user is not an admin' do
      it 'denies creating categories for regular users' do
        expect(subject).not_to permit(create(:user), Category.new)
      end

      it 'denies creating categories for visitors' do
        expect(subject).not_to permit(nil, Category.new)
      end
    end
  end

  permissions :update? do
    context 'when user is an admin' do
      let(:user) { create(:admin_user) }

      it 'allows updating categories' do
        expect(subject).to permit(user, Category.new)
      end
    end

    context 'when user is not an admin' do
      it 'denies updating categories for regular users' do
        expect(subject).not_to permit(create(:user), Category.new)
      end

      it 'denies updating categories for visitors' do
        expect(subject).not_to permit(nil, Category.new)
      end
    end
  end

  permissions :destroy? do
    context 'when user is an admin' do
      let(:user) { create(:admin_user) }

      it 'allows deleting categories' do
        expect(subject).to permit(user, Category.new)
      end
    end

    context 'when user is not an admin' do
      it 'denies deleting categories for regular users' do
        expect(subject).not_to permit(create(:user), Category.new)
      end

      it 'denies deleting categories for visitors' do
        expect(subject).not_to permit(nil, Category.new)
      end
    end
  end
end
