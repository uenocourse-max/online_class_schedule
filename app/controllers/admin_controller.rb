class AdminController < ApplicationController
  before_action -> { require_role!("admin") }
end
