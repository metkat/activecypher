# frozen_string_literal: true

require 'test_helper'

class RelationshipMergeTest < ActiveSupport::TestCase
  def setup
    PersonNode.connection.send(:wipe_database, confirm: 'yes, really')
    HobbyNode.connection.send(:wipe_database, confirm: 'yes, really')
  end

  test "merge fails when from or to nodes don't exist" do
    alice = PersonNode.create(name: 'Alice')
    chess = HobbyNode.new(name: 'Chess')
    
    _error = assert_raises(ActiveCypher::RecordNotSaved) do
      _new_rel = EnjoysRel.find_or_create(from_node: alice, to_node: chess)
    end
  end
  
  
  test 'merge succeeds and returns correct value when relationship already exists' do
    alice = PersonNode.create(name: 'Alice')
    chess = HobbyNode.create(name: 'Chess')
    rel = EnjoysRel.create(from_node: alice, to_node: chess)
    Rails.logger.debug "chess.people are #{chess.people.to_a}"
    new_rel = EnjoysRel.find_or_create(from_node: alice, to_node: chess)
    assert_equal rel.internal_id, new_rel.internal_id
  end

  test "merge succeeds and returns correct value when relationship doesn't already exist" do
    alice = PersonNode.create(name: 'Alice')
    chess = HobbyNode.create(name: 'Chess')
    Rails.logger.debug "chess.people are #{chess.people.to_a}"
    new_rel = EnjoysRel.find_or_create(from_node: alice, to_node: chess)
    assert_not_nil new_rel

  end

end
