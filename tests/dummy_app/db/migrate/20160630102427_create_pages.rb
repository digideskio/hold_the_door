class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.integer :account_id

      t.string  :title
      t.text    :content
      t.string  :state, default: :draft
      t.text    :moderation_comment, default: 'Only for Admins!'

      t.timestamps
    end
  end
end


