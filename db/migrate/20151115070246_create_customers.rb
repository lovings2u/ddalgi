class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|

      t.integer :ord_count #구매횟수
      t.integer :ord_total #총 구매금액
      t.string :phone_number #구매자 핸드폰번호
      t.date :last_order #마지막 구매일자
      t.string :name #구매자 이름
      t.integer :repurchase #재구매빈도

      t.timestamps null: false
    end
  end
end
