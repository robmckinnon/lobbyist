# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_lobbyist_session',
  :secret      => '208d71ec7e8368e192d68dfbb505000bfefe8cd823e37e56a96cd95e5c131bf0062901a61f140dc495c71ed6b391ca66b75bc996f6584d09f0654f4a8a1691ac'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
