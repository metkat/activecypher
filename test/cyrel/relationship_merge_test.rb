# frozen_string_literal: true

require 'test_helper'
require 'cyrel'

class RelationshipMergeTest < ActiveSupport::TestCase
  test 'merge new relationship' do
    alice = Cyrel::Pattern::Node.new(:person, labels: 'Person', properties: { name: 'Alice'})
    chess = Cyrel::Pattern::Node.new(:activity, labels: 'Activity', properties: { name: 'Chess'})
    rel = Cyrel::Pattern::Relationship.new(types: 'ENJOYS', direction: :outgoing)
    path = Cyrel::Pattern::Path.new([alice, rel, chess])

    query = Cyrel::Query.new
                        .merge(path)
                        .return_('*') # return merged relationship, or path?

    expected_cypher = <<~CYPHER.chomp.strip
      MERGE (person:Person {name: $p1})-[:ENJOYS]->(activity:Activity {name: $p2})
      RETURN $p3
    CYPHER
    expected_params = { p1: 'Alice', p2: 'Chess', p3: '*' }
    
    assert_equal [expected_cypher, expected_params], query.to_cypher
  end
  
  # TODO test on existing relationship

end
