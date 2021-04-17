class CreateHouses < ActiveRecord::Migration[6.1]
  def change
    create_table :houses,  id: :string, collation: "utf8_bin", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string "personal_information_id", collation: "utf8_bin"
      t.string "ownership_status"

      t.datetime "deleted_at", index: true
      t.timestamps
    end
  end
end
