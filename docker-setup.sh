#!/bin/bash

echo "What operation would you like to do?"
echo "1. Start the Development Environment"
echo "2. Stop Development Environment"
echo "3. Restart Development Environment"
read -p "Type the number of the process you want to run: " process

if [ $process -eq "1"] || [ $process -eq "3" ]; 

then
    # Start development environment
    docker-compose up --build

    # > Run python commands
    ##  | Make Migrations
    ##  | Create Superuser
    docker-compose exec web python manage.py migrate
    docker-compose exec web python manage.py createsuperuser

else
    docker-compose down

fi