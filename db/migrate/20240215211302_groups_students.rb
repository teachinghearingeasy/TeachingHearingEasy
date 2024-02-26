class GroupsStudents < ActiveRecord::Migration[7.1]
    def change
      create_join_table :groups, :users do |t|
        t.index [:group_id, :user_id]
      end
    end
end
