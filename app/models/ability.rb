class Ability
  include CanCan::Ability

  def initialize(account)
    
    if account && account.admin?
      can :manage, :all
    elsif account && account.manager?
      ability = account.account_permission

      can :read, ability.get_resources_by_action(:read)
      can :manage, ability.get_resources_by_action(:manage)
    end
    
  end
end
