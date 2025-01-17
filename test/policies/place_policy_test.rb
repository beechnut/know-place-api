require 'test_helper'

class PlacePolicyTest < ActiveSupport::TestCase

  def user
    @user ||= users(:exist)
  end

  def place
    @place ||= places(:saved)
  end

  test "visitor can view, create" do
    policy = PlacePolicy.new( nil, place )

    assert policy.show?
    assert policy.create?
    # TODO: People should be able to update places
    # when both the owner and current_user are nil,
    # so long as the place is not completed.
    assert_not policy.edit?
    assert_not policy.update?
    assert_not policy.destroy?
  end

  test "authenticated user can view, create" do
    policy = PlacePolicy.new( user, place )
    assert policy.show?
    assert policy.create?
    assert_not policy.edit?
    assert_not policy.update?
    assert_not policy.destroy?
  end

  test "owner can view, create, edit/update their own" do
    place.user = user
    policy = PlacePolicy.new( user, place )

    assert place.valid?, place.errors.full_messages
    assert policy.show?
    assert policy.create?
    assert policy.edit?
    assert policy.update?
    assert_not policy.destroy?
  end

end
