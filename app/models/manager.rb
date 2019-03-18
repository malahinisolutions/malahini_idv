class Manager < Account
  ACCOUNT_TYPE = "manager"

  default_scope { where(account_type: ACCOUNT_TYPE) }
end