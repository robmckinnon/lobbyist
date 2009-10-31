ActionController::Routing::Routes.draw do |map|
  map.resources :members_interests_entries

  map.resources :members_interests_items

  map.resources :members

  map.root :controller => "application", :action => 'home'

  map.search 'search', :controller => 'application', :action => 'search'

  map.resources :people
  map.resources :appointees
  map.resources :data_sources

  map.show_staff_member 'organisations/:id/:person_id', :controller => 'organisations', :action => 'show_staff_member'
  map.resources :organisations

  map.resources :register_entries
  map.resources :appc_register_entries
  map.resources :appc_register_reports
  map.resources :prca_register_entries

  map.industries 'industries', :controller => 'industries', :action => 'index'
  map.industry 'industries/:sic_section_code', :controller => 'industries', :action => 'show'
  map.industry_class 'industries/:sic_section_code/:sic_class_code', :controller => 'industries', :action => 'show_class'

  map.groups 'groups', :controller => 'organisation_groups', :action => 'index'

  map.special_advisors 'special_advisors', :controller => 'special_advisors', :action => 'index'
  map.special_advisors_list 'special_advisors/:date', :controller => 'special_advisors', :action => 'show'
  map.special_advisor 'special_advisors/:date/:person_id', :controller => 'special_advisors', :action => 'show_advisor'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
