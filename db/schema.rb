# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140725214528) do

  create_table "logs", :force => true do |t|
    t.string   "comment"
    t.string   "filename"
    t.string   "status"
    t.integer  "inrecs"
    t.integer  "outrecs"
    t.integer  "duperecs"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "fileCreateDate"
    t.datetime "lowdate"
    t.datetime "highdate"
    t.integer  "idcount"
    t.binary   "eventfreqs"
  end

  create_table "periods", :force => true do |t|
    t.string   "name"
    t.integer  "ptype"
    t.date     "lodate"
    t.date     "hidate"
    t.date     "voter_reg_lodate"
    t.date     "voter_reg_hidate"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "reports", :force => true do |t|
    t.integer  "report",     :limit => 255
    t.string   "period"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "rprocs", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "vtrs", :force => true do |t|
    t.string   "voterid"
    t.datetime "date"
    t.string   "leo"
    t.string   "formNote"
    t.string   "form"
    t.string   "jurisdiction"
    t.string   "comment"
    t.string   "notes"
    t.string   "action"
    t.string   "election"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "hashAlg"
  end

end
