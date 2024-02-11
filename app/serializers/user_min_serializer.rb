class UserMinSerializer < ActiveModel::Serializer
  attributes :id, :name, :family_id, :secret_santa_id, :santa_group, :is_admin, :birthday
end
