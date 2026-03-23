# Badminton League Tracker

### Technical Prerequisites
- Ruby 2.7.3                                        
- PostgreSQL
  
### Steps to run the tracker in local
1. Clone the repository and navigate into the repo
2. Install dependencies using: `bundle install`
3. Create the database and run migrations using: `rails db:create db:migrate`
4. Start the server using: `rails server`
5. Open http://localhost:3000

If the db connection is failing: update the username and password in the database.yml file